let
    // 1. Source CSV file containing retail sales data
    Source = Csv.Document(
        File.Contents("C:\MYDATA\TRAINING\REPOSITORIES\learning-and-skills\tool-power-bi\20261001-powerbi-training\assignment-03\data\powerbi_hard_retail_sales.csv"),
        [
            Delimiter=",", 
            Columns=26, 
            Encoding=65001, 
            QuoteStyle=QuoteStyle.None
        ]
    )

    // 2. Promote header row
    ,#"Promoted Headers" = Table.PromoteHeaders(
        Source, 
        [PromoteAllScalars=true]
    )

    // 3. Standardize column names: trim, remove spaces, replace % with Pct
    ,#"Standardized Column Names" = Table.TransformColumnNames(
        #"Promoted Headers",
        each Text.Trim(_)
    )

    ,#"Trimmed Text Columns" = Table.TransformColumns(
        #"Standardized Column Names",
        {
            {"Order ID", Text.Trim, type text},
            {"Customer ID", Text.Trim, type text},
            {"Customer Name", Text.Trim, type text},
            {"Customer Email", Text.Trim, type text},
            {"Product ID", Text.Trim, type text},
            {"SKU", Text.Trim, type text},
            {"Product Name", Text.Trim, type text},
            {"Category", Text.Trim, type text},
            {"Region", Text.Trim, type text},
            {"City", Text.Trim, type text},
            {"Sales Channel", Text.Trim, type text},
            {"Sales Rep", Text.Trim, type text},
            {"Currency", Text.Trim, type text},
            {"Payment Method", Text.Trim, type text},
            {"Order Status", Text.Trim, type text},
            {"Promotion Code", Text.Trim, type text},
            {"Warehouse", Text.Trim, type text},
            {"Notes", Text.Trim, type text}
        }
    )

    // 4. Reusable function to convert mixed text dates to Date
    ,CleanDate = (value as any) as nullable date =>
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
    
    // 5. Clean Order Date and Ship Date
    #"Cleaned Dates" = Table.TransformColumns(
        #"Trimmed Text Columns",{
            {"Order Date", CleanDate, type date},
            {"Ship Date", CleanDate, type date}
        }
    )

    // 6. Apply data types to remaining columns
    ,#"Changed Type" = Table.TransformColumnTypes(
        #"Cleaned Dates", {
            {"Order ID", type text}, 
            {"Order Line", Int64.Type}, 
            {"Order Date", type date}, 
            {"Ship Date", type date}, 
            {"Customer ID", type text}, 
            {"Customer Name", type text}, 
            {"Customer Email", type text}, 
            {"Product ID", type text}, 
            {"SKU", type text}, 
            {"Product Name", type text}, 
            {"Category", type text}, 
            {"Region", type text}, 
            {"City", type text}, 
            {"Sales Channel", type text}, 
            {"Sales Rep", type text}, 
            {"Quantity", Int64.Type}, 
            {"Unit Price", type number}, 
            {"Discount %", Int64.Type}, 
            {"Tax Rate", Int64.Type}, 
            {"Shipping Fee", Int64.Type}, 
            {"Currency", type text}, 
            {"Payment Method", type text}, 
            {"Order Status", type text}, 
            {"Promotion Code", type text}, 
            {"Warehouse", type text}, 
            {"Notes", type text}
        }
    )

    // 7. Replace errors in Discount % with null
    ,#"Replaced Errors" = Table.ReplaceErrorValues(
        #"Changed Type", {
            {"Discount %", null}
        }
    )

    ,#"Capitalized Each Word" = Table.TransformColumns(
        #"Replaced Errors",{
            {"Customer Name", Text.Proper, type text},
            {"Product Name", Text.Proper, type text},
            {"Category", Text.Proper, type text},
            {"Region", Text.Proper, type text},
            {"City", Text.Proper, type text},
            {"Sales Channel", Text.Proper, type text},
            {"Sales Rep", Text.Proper, type text},
            {"Order Status", Text.Proper, type text}
        }
    )
    ,#"Lowercased Text" = Table.TransformColumns(
        #"Capitalized Each Word",{
            {"Customer Email", Text.Lower, type text},
            {"Notes", Text.Lower, type text}
        }
    )
in
    #"Lowercased Text"