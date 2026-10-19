let
    Source = Csv.Document(File.Contents("C:\MYDATA\TRAINING\training_power_bi\20261001-powerbi-training\Assignment 2\Product_Master_Lookup.csv"),[Delimiter=",", Columns=5, Encoding=65001, QuoteStyle=QuoteStyle.None]),
    #"Count Before" = Table.RowCount(Source),
    #"Promoted Headers" = Table.PromoteHeaders(Source, [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(
        #"Promoted Headers",
        {
            {"ProductCode", type text}, 
            {"StandardProductName", type text}, 
            {"StandardCategory", type text}, 
            {"Supplier", type text}, 
            {"CostPrice", Int64.Type}
        }
    )
in
    #"Changed Type"