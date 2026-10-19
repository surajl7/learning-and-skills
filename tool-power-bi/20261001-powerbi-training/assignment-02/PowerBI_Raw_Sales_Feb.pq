let
    Source = Csv.Document(
        File.Contents("C:\MYDATA\TRAINING\training_power_bi\20261001-powerbi-training\Assignment 2\PowerBI_Raw_Sales_Feb.csv"),
            [
                Delimiter=",", 
                Columns=16, 
                Encoding=65001, 
                QuoteStyle=QuoteStyle.None
            ]
        ),
    #"Count Before" = Table.RowCount(Source),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            // {"OrderID", type text}, 
            {"OrderDate", type date}
            // {"CustomerFullName", type text}, 
            // {"Email", type text}, 
            // {"Phone", Int64.Type}, 
            // {"ProductCode", type text}, 
            // {"ProductDescription", type text}, 
            // {"Category", type text}, 
            // {"Region", type text}, 
            // {"City", type text}, 
            // {"State", type text}, 
            // {"Status", type text}, 
            // // {"Quantity", Int64.Type}, 
            // // {"UnitPrice", Int64.Type}, 
            // {"SalesRep", type text}, 
            // {"Comments", type text}
        }
    ),
    #"Trimmed Text" = Table.TransformColumns(
        #"Changed Type",
        {
            {"OrderID", Text.Trim, type text}, 
            // {"OrderDate", Text.Trim, type date}, 
            {"CustomerFullName", Text.Trim, type text}, 
            {"Email", Text.Trim, type text}, 
            {"Phone", Text.Trim, Int64.Type}, 
            {"ProductCode", Text.Trim, type text}, 
            {"ProductDescription", Text.Trim, type text}, 
            {"Category", Text.Trim, type text}, 
            {"Region", Text.Trim, type text}, 
            {"City", Text.Trim, type text}, 
            {"State", Text.Trim, type text}, 
            {"Status", Text.Trim, type text}, 
            {"Quantity", Text.Trim, Int64.Type}, 
            {"UnitPrice", Text.Trim, Int64.Type}, 
            {"SalesRep", Text.Trim, type text}, 
            {"Comments", Text.Trim, type text}
        }
    ),
    #"Lowercased Text" = Table.TransformColumns(
        #"Trimmed Text",
        {
            {"Email", Text.Lower, type text}
        }
    ),
    #"Capitalized Text Columns" = Table.TransformColumns(
        #"Lowercased Text",
        {
            {"CustomerFullName", Text.Proper, type text},
            {"ProductDescription", Text.Proper, type text},
            {"Category", Text.Proper, type text},
            {"Region", Text.Proper, type text},
            {"City", Text.Proper, type text},
            {"State", Text.Proper, type text},
            {"Status", Text.Proper, type text},
            {"SalesRep", Text.Proper, type text},
            {"Comments", Text.Proper, type text}
        }
    )
in
    #"Capitalized Text Columns"