let
    // Source CSV file containing retail sales data
    Source = Csv.Document(
        File.Contents("C:\MYDATA\TRAINING\REPOSITORIES\learning-and-skills\tool-power-bi\20261001-powerbi-training\assignment-03\data\powerbi_hard_retail_sales.csv"),
        [
            Delimiter=",", 
            Columns=26, 
            Encoding=65001, 
            QuoteStyle=QuoteStyle.None
        ]
    ),

    // Promote header row
    #"Promoted Headers" = Table.PromoteHeaders(
        Source, 
        [PromoteAllScalars=true]
    ),

    // Standardize column names: trim (keep original names for clarity)
    #"Standardized Column Names" = Table.TransformColumnNames(
        #"Promoted Headers",
        each Text.Trim(_)
    ),

    // Trim text columns (basic cleaning)
    #"Trimmed Text Columns" = Table.TransformColumns(
        #"Standardized Column Names",
        {
            {"Order ID",       Text.Trim, type text},
            {"Customer ID",    Text.Trim, type text},
            {"Customer Name",  Text.Trim, type text},
            {"Customer Email", Text.Trim, type text},
            {"Product ID",     Text.Trim, type text},
            {"SKU",            Text.Trim, type text},
            {"Product Name",   Text.Trim, type text},
            {"Category",       Text.Trim, type text},
            {"Region",         Text.Trim, type text},
            {"City",           Text.Trim, type text},
            {"Sales Channel",  Text.Trim, type text},
            {"Sales Rep",      Text.Trim, type text},
            {"Currency",       Text.Trim, type text},
            {"Payment Method", Text.Trim, type text},
            {"Order Status",   Text.Trim, type text},
            {"Promotion Code", Text.Trim, type text},
            {"Warehouse",      Text.Trim, type text},
            {"Notes",          Text.Trim, type text}
        }
    ),

    // Standardize key text attributes (simple standardization)
    #"Standardized Categorical Text" = Table.TransformColumns(
        #"Trimmed Text Columns",
        {
            {"Customer Name", Text.Proper, type text},
            {"Product Name",  Text.Proper, type text},
            {"Category",      Text.Proper, type text},
            {"Region",        Text.Proper, type text},
            {"City",          Text.Proper, type text},
            {"Sales Channel", Text.Proper, type text},
            {"Sales Rep",     Text.Proper, type text},
            {"Order Status",  Text.Proper, type text},
            {"Payment Method",Text.Proper, type text}
        }
    ),

    #"Lowercased Text" = Table.TransformColumns(
        #"Standardized Categorical Text",
        {
            {"Customer Email", Text.Lower, type text},
            {"Notes",          Text.Lower, type text}
        }
    ),

    // Date-cleaning function (handles mixed formats)
    CleanDate = (value as any) as nullable date =>
        let
            txt = if value = null 
                  then null 
                  else Text.Trim(Text.From(value)),
            result =
                if txt = null or txt = "" then
                    null
                else
                    try Date.FromText(txt, [Culture = "en-US"])
                    otherwise try Date.FromText(txt, [Culture = "en-GB"])
                    otherwise null
        in
            result,

    // Date-quality indicator columns (before conversion)
    #"Added Order Date Status" = Table.AddColumn(
        #"Lowercased Text",
        "Order Date Status",
        each 
            let
                txt = if [Order Date] = null then null else Text.Trim(Text.From([Order Date])),
                parsed =
                    if txt = null or txt = "" then null
                    else
                        try Date.FromText(txt, [Culture = "en-US"]) 
                        otherwise try Date.FromText(txt, [Culture = "en-GB"]) 
                        otherwise null
            in
                if txt = null or txt = "" then "Missing"
                else if parsed = null then "Invalid"
                else "Valid",
        type text
    ),

    #"Added Ship Date Status" = Table.AddColumn(
        #"Added Order Date Status",
        "Ship Date Status",
        each 
            let
                txt = if [Ship Date] = null then null else Text.Trim(Text.From([Ship Date])),
                parsed =
                    if txt = null or txt = "" then null
                    else
                        try Date.FromText(txt, [Culture = "en-US"]) 
                        otherwise try Date.FromText(txt, [Culture = "en-GB"]) 
                        otherwise null
            in
                if txt = null or txt = "" then "Missing"
                else if parsed = null then "Invalid"
                else "Valid",
        type text
    ),

    // Convert Order Date and Ship Date to proper dates (using CleanDate)
    #"Cleaned Dates" = Table.TransformColumns(
        #"Added Ship Date Status",
        {
            {"Order Date", CleanDate, type date},
            {"Ship Date",  CleanDate, type date}
        }
    )

    // Data-quality for Quantity and Product ID BEFORE numeric conversion
    ,#"Added Quantity Status" = Table.AddColumn(
        #"Cleaned Dates",
        "Quantity Status",
        each 
            let
                v   = [Quantity],
                txt = if v = null then null else Text.Trim(Text.From(v)),
                num = if txt = null or txt = "" then null else try Number.From(txt) otherwise null
            in
                if txt = null or txt = "" then "Missing"
                else if num = null then "Invalid"
                else if num < 0 then "Negative"
                else "Valid",
        type text
    ),

    #"Added ProductID Status" = Table.AddColumn(
        #"Added Quantity Status",
        "Product ID Status",
        each 
            let txt = if [Product ID] = null then null else Text.Trim([Product ID])
            in  if txt = null or txt = "" then "Missing" else "Present",
        type text
    )

    // Numeric validity flags for Discount %, Tax Rate, Shipping Fee
    ,#"Added Discount Status" = Table.AddColumn(
        #"Added ProductID Status",
        "Discount Status",
        each 
            let
                v   = [#"Discount %"],
                txt = if v = null then null else Text.Trim(Text.From(v)),
                num = if txt = null or txt = "" then null else try Number.From(txt) otherwise null
            in
                if txt = null or txt = "" then "Missing"
                else if num = null then "Invalid"
                else "Valid",
        type text
    )

    ,#"Added TaxRate Status" = Table.AddColumn(
        #"Added Discount Status",
        "Tax Rate Status",
        each 
            let
                v   = [Tax Rate],
                txt = if v = null then null else Text.Trim(Text.From(v)),
                num = if txt = null or txt = "" then null else try Number.From(txt) otherwise null
            in
                if txt = null or txt = "" then "Missing"
                else if num = null then "Invalid"
                else "Valid",
        type text
    ),

    #"Added ShippingFee Status" = Table.AddColumn(
        #"Added TaxRate Status",
        "Shipping Fee Status",
        each 
            let
                v   = [Shipping Fee],
                txt = if v = null then null else Text.Trim(Text.From(v)),
                num = if txt = null or txt = "" then null else try Number.From(txt) otherwise null
            in
                if txt = null or txt = "" then "Missing"
                else if num = null then "Invalid"
                else "Valid",
        type text
    ),

    // Convert numeric columns safely (no errors; invalid -> null but flagged above)
    #"Converted Numerics" = Table.TransformColumns(
        #"Added ShippingFee Status",
        {
            {"Order Line",   each try Number.From(_) otherwise null, Int64.Type},
            {"Quantity",     each try Number.From(_) otherwise null, Int64.Type},
            {"Unit Price",   each try Number.From(_) otherwise null, type number},
            {"Discount %",   each try Number.From(_) otherwise null, type number},
            {"Tax Rate",     each try Number.From(_) otherwise null, type number},
            {"Shipping Fee", each try Number.From(_) otherwise null, type number}
        }
    ),

    // Composite transaction key (Order ID + Order Line)
    #"Added Transaction Key" = Table.AddColumn(
        #"Converted Numerics",
        "Transaction Key",
        each Text.From([Order ID]) & "-" & Text.From([Order Line]),
        type text
    ),

    // Detect duplicate Order ID + Order Line combinations
    #"Grouped By OrderLine" = Table.Group(
        #"Added Transaction Key",
        {"Order ID", "Order Line"},
        {{"Count OrderLine", each Table.RowCount(_), Int64.Type}}
    ),

    #"Merged OrderLine Counts" = Table.NestedJoin(
        #"Added Transaction Key",
        {"Order ID", "Order Line"},
        #"Grouped By OrderLine",
        {"Order ID", "Order Line"},
        "OrderLineCounts",
        JoinKind.LeftOuter
    )

    ,#"Expanded OrderLine Counts" = Table.ExpandTableColumn(
        #"Merged OrderLine Counts",
        "OrderLineCounts",
        {"Count OrderLine"},
        {"Count OrderLine"}
    ),

    #"Added Duplicate OrderLine Flag" = Table.AddColumn(
        #"Expanded OrderLine Counts",
        "Duplicate OrderLine Status",
        each if [Count OrderLine] <> null and [Count OrderLine] > 1 then "Duplicate" else "Unique",
        type text
    ),

    // Detect exact duplicates (all columns identical)
    //     Group on all columns and bring back a count
    AllColumns = Table.ColumnNames(#"Added Duplicate OrderLine Flag"),

    #"Grouped All Columns" = Table.Group(
        #"Added Duplicate OrderLine Flag",
        AllColumns,
        {{"ExactDuplicateCount", each Table.RowCount(_), Int64.Type}}
    ),

    #"Merged ExactDuplicateCount" = Table.NestedJoin(
        #"Added Duplicate OrderLine Flag",
        AllColumns,
        #"Grouped All Columns",
        AllColumns,
        "ExactDupInfo",
        JoinKind.LeftOuter
    ),

    #"Expanded ExactDuplicateCount" = Table.ExpandTableColumn(
        #"Merged ExactDuplicateCount",
        "ExactDupInfo",
        {"ExactDuplicateCount"},
        {"ExactDuplicateCount"}
    ),

    #"Added ExactDuplicate Status" = Table.AddColumn(
        #"Expanded ExactDuplicateCount",
        "Exact Duplicate Status",
        each if [ExactDuplicateCount] <> null and [ExactDuplicateCount] > 1 then "Exact Duplicate" else "Unique",
        type text
    ),

    // Calculated business columns in PQ
    //     Assume Discount % and Tax Rate are stored as percentages (e.10 = 10%)
    #"Added Discount Rate" = Table.AddColumn(
        #"Added ExactDuplicate Status",
        "Discount Rate",
        each if [#"Discount %"] = null then null else [#"Discount %"] / 100,
        type number
    ),

    #"Added Tax Rate Decimal" = Table.AddColumn(
        #"Added Discount Rate",
        "Tax Rate Decimal",
        each if [Tax Rate] = null then null else [Tax Rate] / 100,
        type number
    ),

    #"Added Gross Sales" = Table.AddColumn(
        #"Added Tax Rate Decimal",
        "Gross Sales",
        each if [Quantity] = null or [Unit Price] = null then null else [Quantity] * [Unit Price],
        type number
    ),

    #"Added Discount Amount" = Table.AddColumn(
        #"Added Gross Sales",
        "Discount Amount",
        each if [Gross Sales] = null or [Discount Rate] = null then null else [Gross Sales] * [Discount Rate],
        type number
    ),

    #"Added Net Sales" = Table.AddColumn(
        #"Added Discount Amount",
        "Net Sales",
        each if [Gross Sales] = null then null else [Gross Sales] - (if [Discount Amount] = null then 0 else [Discount Amount]),
        type number
    ),

    #"Added Tax Amount" = Table.AddColumn(
        #"Added Net Sales",
        "Tax Amount",
        each if [Net Sales] = null or [Tax Rate Decimal] = null then null else [Net Sales] * [Tax Rate Decimal],
        type number
    ),

    #"Added Invoice Amount" = Table.AddColumn(
        #"Added Tax Amount",
        "Invoice Amount",
        each 
            if [Net Sales] = null then null 
            else [Net Sales] 
                 + (if [Tax Amount] = null then 0 else [Tax Amount]) 
                 + (if [Shipping Fee] = null then 0 else [Shipping Fee]),
        type number
    ),

    // Shipping Days = Ship Date - Order Date
    #"Added Shipping Days" = Table.AddColumn(
        #"Added Invoice Amount",
        "Shipping Days",
        each 
            if [Ship Date] = null or [Order Date] = null then null
            else Duration.Days([Ship Date] - [Order Date]),
        Int64.Type
    ),

    // Date attributes: Order year, month, year-month, financial quarter (calendar-based)
    #"Added Order Year" = Table.AddColumn(
        #"Added Shipping Days",
        "Order Year",
        each if [Order Date] = null then null else Date.Year([Order Date]),
        Int64.Type
    )

    ,#"Added Order Month" = Table.AddColumn(
        #"Added Order Year",
        "Order Month",
        each if [Order Date] = null then null else Date.Month([Order Date]),
        Int64.Type
    ),

    #"Added YearMonth" = Table.AddColumn(
        #"Added Order Month",
        "Year-Month",
        each if [Order Date] = null then null else Date.ToText([Order Date], "yyyy-MM"),
        type text
    ),

    #"Added Financial Quarter" = Table.AddColumn(
        #"Added YearMonth",
        "Financial Quarter",
        each if [Order Date] = null then null else "Q" & Number.ToText(Date.QuarterOfYear([Order Date])),
        type text
    ),

    // Promotion-valid flag (placeholder until you join to DimPromotion)
    //     For now: has promotion code = "Has Promotion", else "No Promotion"
    #"Added Promotion Valid Flag" = Table.AddColumn(
        #"Added Financial Quarter",
        "Promotion Valid Flag",
        each if [Promotion Code] = null or [Promotion Code] = "" then "No Promotion" else "Has Promotion",
        type text
    ),

    // Late-shipment flag (example: late if > 5 days; adjust rule as needed)
    #"Added Late Shipment Flag" = Table.AddColumn(
        #"Added Promotion Valid Flag",
        "Late Shipment Flag",
        each 
            if [Shipping Days] = null then "Unknown"
            else if [Shipping Days] > 5 then "Late"
            else "On Time",
        type text
    ),

    // Overall Data-quality status (summary of main issues)
    #"Added Data Quality Status" = Table.AddColumn(
        #"Added Late Shipment Flag",
        "Data-quality Status",
        each 
            if [Order Date Status] <> "Valid" or [Ship Date Status] <> "Valid" then "Date Issue"
            else if [Quantity Status] <> "Valid" then "Quantity Issue"
            else if [Product ID Status] <> "Present" then "Missing Product"
            else if [Duplicate OrderLine Status] = "Duplicate" then "Duplicate Order Line"
            else if [Exact Duplicate Status] = "Exact Duplicate" then "Exact Duplicate"
            else "OK",
        type text
    )

in
    #"Added Data Quality Status"
