let
    Source = fact_sales,
    #"Selected Columns" = Table.SelectColumns(Source, {"Warehouse"}),
    #"Distinct Warehouses" = Table.Distinct(#"Selected Columns")
in
    #"Distinct Warehouses"
