let
    Source = fact_sales,
    #"Selected Columns" = Table.SelectColumns(Source, {"Sales Rep"}),
    #"Distinct SalesReps" = Table.Distinct(#"Selected Columns")
in
    #"Distinct SalesReps"
