let
    Products = raw_reference_data[products],

    // Keep only Product ID and Attributes
    ProductAttributeRecords = List.Transform(
        Products,
        each
            [
                ProductID = Record.FieldOrDefault(_, "ProductID", null),
                Attributes = Record.FieldOrDefault(_, "Attributes", {})
            ]
    ),

    #"Converted to Table" = Table.FromRecords(
        ProductAttributeRecords,
        {
            "ProductID",
            "Attributes"
        },
        MissingField.UseNull
    ),

    // Expand attributes into rows
    #"Expanded Attributes" = Table.ExpandListColumn(
        #"Converted to Table",
        "Attributes"
    ),

    // Keep valid attributes
    #"Filtered Attributes" = Table.SelectRows(
        #"Expanded Attributes",
        each [Attributes] <> null
    ),

    // Expand attribute Name and Value
    #"Expanded Attribute Record" = Table.ExpandRecordColumn(
        #"Filtered Attributes",
        "Attributes",
        {
            "Name",
            "Value"
        },
        {
            "Attribute Name",
            "Attribute Value"
        }
    ),

    // Convert mixed attribute values to text
    #"Converted Attribute Value" = Table.TransformColumns(
        #"Expanded Attribute Record",
        {
            {
                "Attribute Value",
                each if _ = null then null else Text.From(_),
                type nullable text
            }
        }
    ),

    // Pivot attribute names into separate columns
    #"Pivoted Attributes" = Table.Pivot(
        #"Converted Attribute Value",
        List.Distinct(
            #"Converted Attribute Value"[Attribute Name]
        ),
        "Attribute Name",
        "Attribute Value",
        List.First
    ),

    // Rename columns
    #"Renamed Columns" = Table.RenameColumns(
        #"Pivoted Attributes",
        {
            {"ProductID", "Product ID"},
            {"WarrantyMonths", "Warranty Months"},
            {"Active", "Active Status"}
        },
        MissingField.Ignore
    ),

    // Convert Warranty values such as 12 and "12 months" to 12
    #"Cleaned Warranty Months" = Table.TransformColumns(
        #"Renamed Columns",
        {
            {
                "Warranty Months",
                each
                    if _ = null then
                        null
                    else
                        try Int64.From(
                            Text.Select(
                                Text.From(_),
                                {"0".."9"}
                            )
                        )
                        otherwise null,
                Int64.Type
            }
        }
    ),

    // Standardize Active values such as true and Yes
    #"Cleaned Active Status" = Table.TransformColumns(
        #"Cleaned Warranty Months",
        {
            {
                "Active Status",
                each
                    if _ = null then
                        null
                    else if List.Contains(
                        {"TRUE", "YES", "Y"},
                        Text.Upper(Text.Trim(Text.From(_)))
                    ) then
                        true
                    else if List.Contains(
                        {"FALSE", "NO", "N"},
                        Text.Upper(Text.Trim(Text.From(_)))
                    ) then
                        false
                    else
                        null,
                type nullable logical
            }
        }
    )

in
    #"Cleaned Active Status"