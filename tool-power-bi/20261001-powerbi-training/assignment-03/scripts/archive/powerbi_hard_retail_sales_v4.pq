let
    // ============================================================
    // SOURCE
    // ============================================================

    Source = Csv.Document(
        File.Contents(
            "C:\MYDATA\TRAINING\REPOSITORIES\learning-and-skills\tool-power-bi\20261001-powerbi-training\assignment-03\data\powerbi_hard_retail_sales.csv"
        ),
        [
            Delimiter = ",",
            Columns = 26,
            Encoding = 65001,
            QuoteStyle = QuoteStyle.None
        ]
    ),

    #"Promoted Headers" = Table.PromoteHeaders(
        Source,
        [PromoteAllScalars = true]
    ),

    #"Standardized Column Names" = Table.TransformColumnNames(
        #"Promoted Headers",
        each Text.Trim(_)
    ),


    // ============================================================
    // REUSABLE FUNCTIONS
    // ============================================================

    CleanDate = (value as any) as nullable date =>
        let
            TextValue =
                if value = null then
                    null
                else
                    Text.Trim(Text.From(value)),

            ParsedDate =
                if TextValue = null or TextValue = "" then
                    null
                else
                    try Date.FromText(
                        TextValue,
                        [Culture = "en-US"]
                    )
                    otherwise try Date.FromText(
                        TextValue,
                        [Culture = "en-GB"]
                    )
                    otherwise null
        in
            ParsedDate,

    DateStatus = (value as any) as text =>
        let
            TextValue =
                if value = null then
                    null
                else
                    Text.Trim(Text.From(value)),

            ParsedDate = CleanDate(value)
        in
            if TextValue = null or TextValue = "" then
                "Missing"
            else if ParsedDate = null then
                "Invalid"
            else
                "Valid",

    NumericStatus = (
        value as any,
        optional CheckNegative as nullable logical
    ) as text =>
        let
            TextValue =
                if value = null then
                    null
                else
                    Text.Trim(Text.From(value)),

            ParsedNumber =
                if TextValue = null or TextValue = "" then
                    null
                else
                    try Number.From(TextValue) otherwise null,

            ShouldCheckNegative =
                if CheckNegative = null then
                    false
                else
                    CheckNegative
        in
            if TextValue = null or TextValue = "" then
                "Missing"
            else if ParsedNumber = null then
                "Invalid"
            else if ShouldCheckNegative and ParsedNumber < 0 then
                "Negative"
            else
                "Valid",

    SafeText = (value as any) as nullable text =>
        if value = null then
            null
        else
            Text.Trim(Text.From(value)),


    // ============================================================
    // TEXT CLEANING
    // ============================================================

    TextColumns = {
        "Order ID",
        "Customer ID",
        "Customer Name",
        "Customer Email",
        "Product ID",
        "SKU",
        "Product Name",
        "Category",
        "Region",
        "City",
        "Sales Channel",
        "Sales Rep",
        "Currency",
        "Payment Method",
        "Order Status",
        "Promotion Code",
        "Warehouse",
        "Notes"
    },

    ProperCaseColumns = {
        "Customer Name",
        "Product Name",
        "Category",
        "Region",
        "City",
        "Sales Channel",
        "Sales Rep",
        "Order Status",
        "Payment Method"
    },

    LowercaseColumns = {
        "Customer Email",
        "Notes"
    },

    #"Trimmed Text Columns" = Table.TransformColumns(
        #"Standardized Column Names",
        List.Transform(
            TextColumns,
            each {
                _,
                (value) => SafeText(value),
                type nullable text
            }
        )
    ),

    #"Standardized Categorical Text" = Table.TransformColumns(
        #"Trimmed Text Columns",
        List.Transform(
            ProperCaseColumns,
            each {
                _,
                (value) =>
                    if value = null then
                        null
                    else
                        Text.Proper(value),
                type nullable text
            }
        )
    ),

    #"Lowercased Text" = Table.TransformColumns(
        #"Standardized Categorical Text",
        List.Transform(
            LowercaseColumns,
            each {
                _,
                (value) =>
                    if value = null then
                        null
                    else
                        Text.Lower(value),
                type nullable text
            }
        )
    ),


    // ============================================================
    // DATE VALIDATION AND CONVERSION
    // ============================================================

    #"Added Date Statuses" = Table.AddColumn(
        #"Lowercased Text",
        {
            {
                "Order Date Status",
                each DateStatus([Order Date]),
                type text
            },
            {
                "Ship Date Status",
                each DateStatus([Ship Date]),
                type text
            }
        }
    ),

    DateColumns = {
        "Order Date",
        "Ship Date"
    },

    #"Cleaned Dates" = Table.TransformColumns(
        #"Added Date Statuses",
        List.Transform(
            DateColumns,
            each {
                _,
                CleanDate,
                type nullable date
            }
        )
    ),


    // ============================================================
    // DATA-QUALITY STATUS COLUMNS
    // ============================================================

    #"Added Source Statuses" = Table.AddColumn(
        #"Cleaned Dates",
        {
            {
                "Quantity Status",
                each NumericStatus([Quantity], true),
                type text
            },
            {
                "Product ID Status",
                each
                    if [Product ID] = null or [Product ID] = "" then
                        "Missing"
                    else
                        "Present",
                type text
            },
            {
                "Discount Status",
                each NumericStatus([#"Discount %"]),
                type text
            },
            {
                "Tax Rate Status",
                each NumericStatus([Tax Rate]),
                type text
            },
            {
                "Shipping Fee Status",
                each NumericStatus([Shipping Fee]),
                type text
            }
        }
    ),


    // ============================================================
    // NUMERIC CONVERSION
    // ============================================================

    WholeNumberColumns = {
        "Order Line",
        "Quantity"
    },

    DecimalNumberColumns = {
        "Unit Price",
        "Discount %",
        "Tax Rate",
        "Shipping Fee"
    },

    WholeNumberTransformations = List.Transform(
        WholeNumberColumns,
        each {
            _,
            (value) =>
                try Int64.From(Number.From(value))
                otherwise null,
            Int64.Type
        }
    ),

    DecimalNumberTransformations = List.Transform(
        DecimalNumberColumns,
        each {
            _,
            (value) =>
                try Number.From(value)
                otherwise null,
            type nullable number
        }
    ),

    #"Converted Numerics" = Table.TransformColumns(
        #"Added Source Statuses",
        List.Combine(
            {
                WholeNumberTransformations,
                DecimalNumberTransformations
            }
        )
    ),


    // ============================================================
    // EXACT DUPLICATE CHECK
    //    Uses cleaned source columns before calculated columns
    // ============================================================

    BusinessColumns = {
        "Order ID",
        "Order Line",
        "Order Date",
        "Ship Date",
        "Customer ID",
        "Customer Name",
        "Customer Email",
        "Product ID",
        "SKU",
        "Product Name",
        "Category",
        "Region",
        "City",
        "Sales Channel",
        "Sales Rep",
        "Quantity",
        "Unit Price",
        "Discount %",
        "Tax Rate",
        "Shipping Fee",
        "Currency",
        "Payment Method",
        "Order Status",
        "Promotion Code",
        "Warehouse",
        "Notes"
    },

    #"Grouped Exact Duplicates" = Table.Group(
        #"Converted Numerics",
        BusinessColumns,
        {
            {
                "Exact Duplicate Count",
                each Table.RowCount(_),
                Int64.Type
            }
        }
    ),

    #"Merged Exact Duplicates" = Table.NestedJoin(
        #"Converted Numerics",
        BusinessColumns,
        #"Grouped Exact Duplicates",
        BusinessColumns,
        "Exact Duplicate Information",
        JoinKind.LeftOuter
    ),

    #"Expanded Exact Duplicate Count" = Table.ExpandTableColumn(
        #"Merged Exact Duplicates",
        "Exact Duplicate Information",
        {"Exact Duplicate Count"},
        {"Exact Duplicate Count"}
    ),

    #"Added Exact Duplicate Status" = Table.AddColumn(
        #"Expanded Exact Duplicate Count",
        "Exact Duplicate Status",
        each
            if [Exact Duplicate Count] > 1 then
                "Exact Duplicate"
            else
                "Unique",
        type text
    ),


    // ============================================================
    // TRANSACTION KEY AND ORDER-LINE DUPLICATES
    // ============================================================

    #"Added Transaction Key" = Table.AddColumn(
        #"Added Exact Duplicate Status",
        "Transaction Key",
        each
            if [Order ID] = null or [Order Line] = null then
                null
            else
                [Order ID] & "-" & Text.From([Order Line]),
        type nullable text
    ),

    #"Grouped Order Lines" = Table.Group(
        #"Added Transaction Key",
        {
            "Order ID",
            "Order Line"
        },
        {
            {
                "Order Line Count",
                each Table.RowCount(_),
                Int64.Type
            }
        }
    ),

    #"Merged Order Line Counts" = Table.NestedJoin(
        #"Added Transaction Key",
        {
            "Order ID",
            "Order Line"
        },
        #"Grouped Order Lines",
        {
            "Order ID",
            "Order Line"
        },
        "Order Line Information",
        JoinKind.LeftOuter
    ),

    #"Expanded Order Line Count" = Table.ExpandTableColumn(
        #"Merged Order Line Counts",
        "Order Line Information",
        {"Order Line Count"},
        {"Order Line Count"}
    ),

    #"Added Duplicate Order Line Status" = Table.AddColumn(
        #"Expanded Order Line Count",
        "Duplicate OrderLine Status",
        each
            if [Order Line Count] > 1 then
                "Duplicate"
            else
                "Unique",
        type text
    ),


    // ============================================================
    // BUSINESS CALCULATIONS
    // ============================================================

    #"Added Business Calculations" = Table.AddColumn(
        #"Added Duplicate Order Line Status",
        "Business Calculations",
        each
            let
                DiscountRate =
                    if [#"Discount %"] = null then
                        null
                    else
                        [#"Discount %"] / 100,

                TaxRateDecimal =
                    if [Tax Rate] = null then
                        null
                    else
                        [Tax Rate] / 100,

                GrossSales =
                    if [Quantity] = null or [Unit Price] = null then
                        null
                    else
                        [Quantity] * [Unit Price],

                DiscountAmount =
                    if GrossSales = null or DiscountRate = null then
                        null
                    else
                        GrossSales * DiscountRate,

                NetSales =
                    if GrossSales = null then
                        null
                    else
                        GrossSales -
                        (
                            if DiscountAmount = null then
                                0
                            else
                                DiscountAmount
                        ),

                TaxAmount =
                    if NetSales = null or TaxRateDecimal = null then
                        null
                    else
                        NetSales * TaxRateDecimal,

                InvoiceAmount =
                    if NetSales = null then
                        null
                    else
                        NetSales
                            + (
                                if TaxAmount = null then
                                    0
                                else
                                    TaxAmount
                              )
                            + (
                                if [Shipping Fee] = null then
                                    0
                                else
                                    [Shipping Fee]
                              )
            in
                [
                    DiscountRate = DiscountRate,
                    TaxRateDecimal = TaxRateDecimal,
                    GrossSales = GrossSales,
                    DiscountAmount = DiscountAmount,
                    NetSales = NetSales,
                    TaxAmount = TaxAmount,
                    InvoiceAmount = InvoiceAmount
                ],
        type record
    ),

    #"Expanded Business Calculations" = Table.ExpandRecordColumn(
        #"Added Business Calculations",
        "Business Calculations",
        {
            "DiscountRate",
            "TaxRateDecimal",
            "GrossSales",
            "DiscountAmount",
            "NetSales",
            "TaxAmount",
            "InvoiceAmount"
        },
        {
            "Discount Rate",
            "Tax Rate Decimal",
            "Gross Sales",
            "Discount Amount",
            "Net Sales",
            "Tax Amount",
            "Invoice Amount"
        }
    ),

    #"Typed Business Calculations" = Table.TransformColumnTypes(
        #"Expanded Business Calculations",
        {
            {"Discount Rate", type number},
            {"Tax Rate Decimal", type number},
            {"Gross Sales", type number},
            {"Discount Amount", type number},
            {"Net Sales", type number},
            {"Tax Amount", type number},
            {"Invoice Amount", type number}
        }
    ),


    // ============================================================
    // SHIPPING AND DATE ATTRIBUTES
    // ============================================================

    #"Added Shipping Days" = Table.AddColumn(
        #"Typed Business Calculations",
        "Shipping Days",
        each
            if [Ship Date] = null or [Order Date] = null then
                null
            else
                Duration.Days([Ship Date] - [Order Date]),
        Int64.Type
    ),

    #"Added Date Attributes" = Table.AddColumn(
        #"Added Shipping Days",
        "Date Attributes",
        each
            if [Order Date] = null then
                [
                    OrderYear = null,
                    OrderMonth = null,
                    YearMonth = null,
                    FinancialQuarter = null
                ]
            else
                [
                    OrderYear = Date.Year([Order Date]),
                    OrderMonth = Date.Month([Order Date]),
                    YearMonth = Date.ToText([Order Date], "yyyy-MM"),
                    FinancialQuarter =
                        "Q" &
                        Number.ToText(
                            Date.QuarterOfYear([Order Date])
                        )
                ],
        type record
    ),

    #"Expanded Date Attributes" = Table.ExpandRecordColumn(
        #"Added Date Attributes",
        "Date Attributes",
        {
            "OrderYear",
            "OrderMonth",
            "YearMonth",
            "FinancialQuarter"
        },
        {
            "Order Year",
            "Order Month",
            "Year-Month",
            "Financial Quarter"
        }
    ),

    #"Typed Date Attributes" = Table.TransformColumnTypes(
        #"Expanded Date Attributes",
        {
            {"Order Year", Int64.Type},
            {"Order Month", Int64.Type},
            {"Year-Month", type text},
            {"Financial Quarter", type text}
        }
    ),


    // ============================================================
    // BUSINESS FLAGS
    // ============================================================

    #"Added Business Flags" = Table.AddColumn(
        Table.AddColumn(
            #"Typed Date Attributes",
            "Promotion Valid Flag",
            each
                if [Promotion Code] = null or [Promotion Code] = "" then
                    "No Promotion"
                else
                    "Has Promotion",
            type text
        ),
        "Late Shipment Flag",
        each
            if [Shipping Days] = null then
                "Unknown"
            else if [Shipping Days] > 5 then
                "Late"
            else
                "On Time",
        type text
    ),


    // ============================================================
    // OVERALL DATA-QUALITY STATUS
    // ============================================================

    #"Added Data Quality Status" = Table.AddColumn(
        #"Added Business Flags",
        "Data-quality Status",
        each
            if [Order Date Status] <> "Valid"
                or [Ship Date Status] <> "Valid"
            then
                "Date Issue"

            else if [Quantity Status] <> "Valid" then
                "Quantity Issue"

            else if [Product ID Status] <> "Present" then
                "Missing Product"

            else if [Discount Status] <> "Valid" then
                "Discount Issue"

            else if [Tax Rate Status] <> "Valid" then
                "Tax Rate Issue"

            else if [Shipping Fee Status] <> "Valid" then
                "Shipping Fee Issue"

            else if [Duplicate OrderLine Status] = "Duplicate" then
                "Duplicate Order Line"

            else if [Exact Duplicate Status] = "Exact Duplicate" then
                "Exact Duplicate"

            else
                "OK",
        type text
    )

in
    #"Added Data Quality Status"