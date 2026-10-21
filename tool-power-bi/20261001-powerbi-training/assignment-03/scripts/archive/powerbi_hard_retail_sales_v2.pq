let
    // 1. Source CSV file containing retail sales data
    Source = Csv.Document(
        File.Contents("C:\MYDATA\TRAINING\REPOSITORIES\learning-and-skills\tool-power-bi\20261001-powerbi-training\assignment-03\data\powerbi_hard_retail_sales.csv"),
        [
            Delimiter = ",", 
            Columns = 26, 
            Encoding = 65001, 
            QuoteStyle = QuoteStyle.None
        ]
    ),

    // 2. Promote header row
    #"Promoted Headers" = Table.PromoteHeaders(
        Source, 
        [PromoteAllScalars = true]
    ),

    // 3. Standardize column names: trim, remove spaces, replace % with Pct
    #"Standardized Column Names" = Table.TransformColumnNames(
        #"Promoted Headers",
        each 
            let
                trimmed   = Text.Trim(_),
                noSpaces  = Text.Replace(trimmed, " ", ""),
                noPercent = Text.Replace(noSpaces, "%", "Pct")
            in
                noPercent
    ),

    // 4. Trim text columns
    #"Trimmed Text Columns" = Table.TransformColumns(
        #"Standardized Column Names",
        {
            {"OrderID",       Text.Trim, type text},
            {"CustomerID",    Text.Trim, type text},
            {"CustomerName",  Text.Trim, type text},
            {"CustomerEmail", Text.Trim, type text},
            {"ProductID",     Text.Trim, type text},
            {"SKU",           Text.Trim, type text},
            {"ProductName",   Text.Trim, type text},
            {"Category",      Text.Trim, type text},
            {"Region",        Text.Trim, type text},
            {"City",          Text.Trim, type text},
            {"SalesChannel",  Text.Trim, type text},
            {"SalesRep",      Text.Trim, type text},
            {"Currency",      Text.Trim, type text},
            {"PaymentMethod", Text.Trim, type text},
            {"OrderStatus",   Text.Trim, type text},
            {"PromotionCode", Text.Trim, type text},
            {"Warehouse",     Text.Trim, type text},
            {"Notes",         Text.Trim, type text}
        }
    ),

    // 5. Reusable function to convert mixed text dates to Date
    CleanDate = (value as any) as nullable date =>
        let
            txt =
                if value = null 
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

    // 6. Date-quality flags BEFORE conversion (so you know if it was invalid vs just blank)
    #"Added OrderDate Status" = Table.AddColumn(
        #"Trimmed Text Columns",
        "OrderDateStatus",
        each 
            let
                txt = if [OrderDate] = null then null else Text.Trim(Text.From([OrderDate])),
                parsedUS = try Date.FromText(txt, [Culture = "en-US"]) otherwise null,
                parsedGB = if parsedUS <> null then parsedUS else (try Date.FromText(txt, [Culture = "en-GB"]) otherwise null)
            in
                if txt = null or txt = "" then "Missing"
                else if parsedUS = null and parsedGB = null then "Invalid"
                else "Valid",
        type text
    ),

    #"Added ShipDate Status" = Table.AddColumn(
        #"Added OrderDate Status",
        "ShipDateStatus",
        each 
            let
                txt = if [ShipDate] = null then null else Text.Trim(Text.From([ShipDate])),
                parsedUS = try Date.FromText(txt, [Culture = "en-US"]) otherwise null,
                parsedGB = if parsedUS <> null then parsedUS else (try Date.FromText(txt, [Culture = "en-GB"]) otherwise null)
            in
                if txt = null or txt = "" then "Missing"
                else if parsedUS = null and parsedGB = null then "Invalid"
                else "Valid",
        type text
    ),

    // 7. Clean OrderDate and ShipDate into proper Date types
    #"Cleaned Dates" = Table.TransformColumns(
        #"Added ShipDate Status",
        {
            {"OrderDate", CleanDate, type date},
            {"ShipDate", CleanDate, type date}
        }
    ),

    // 8. Apply data types to remaining columns
    //    (use decimals for prices, percentages, tax, and shipping)
    #"Changed Type" = Table.TransformColumnTypes(
        #"Cleaned Dates",
        {
            {"OrderID",       type text}, 
            {"OrderLine",     Int64.Type}, 
            {"OrderDate",     type date}, 
            {"ShipDate",      type date}, 
            {"CustomerID",    type text}, 
            {"CustomerName",  type text}, 
            {"CustomerEmail", type text}, 
            {"ProductID",     type text}, 
            {"SKU",           type text}, 
            {"ProductName",   type text}, 
            {"Category",      type text}, 
            {"Region",        type text}, 
            {"City",          type text}, 
            {"SalesChannel",  type text}, 
            {"SalesRep",      type text}, 
            {"Quantity",      Int64.Type}, 
            {"UnitPrice",     type number}, 
            {"DiscountPct",   type number}, 
            {"TaxRate",       type number}, 
            {"ShippingFee",   type number}, 
            {"Currency",      type text}, 
            {"PaymentMethod", type text}, 
            {"OrderStatus",   type text}, 
            {"PromotionCode", type text}, 
            {"Warehouse",     type text}, 
            {"Notes",         type text}
        }
    ),

    // 9. Standardize casing
    #"Capitalized Each Word" = Table.TransformColumns(
        #"Changed Type",
        {
            {"CustomerName", Text.Proper, type text},
            {"ProductName",  Text.Proper, type text},
            {"Category",     Text.Proper, type text},
            {"Region",       Text.Proper, type text},
            {"City",         Text.Proper, type text},
            {"SalesChannel", Text.Proper, type text},
            {"SalesRep",     Text.Proper, type text},
            {"OrderStatus",  Text.Proper, type text}
        }
    ),

    #"Lowercased Text" = Table.TransformColumns(
        #"Capitalized Each Word",
        {
            {"CustomerEmail", Text.Lower, type text},
            {"Notes",         Text.Lower, type text}
        }
    )

in
    #"Lowercased Text"