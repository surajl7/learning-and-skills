let
    Products = raw_reference_data[products],

    ProductRecords = List.Transform(
        Products,
        each
            [
                ProductID = Record.FieldOrDefault(_, "ProductID", null),
                SKU = Record.FieldOrDefault(_, "SKU", null),
                ProductName = Record.FieldOrDefault(_, "ProductName", null),
                Attributes = Record.FieldOrDefault(_, "Attributes", {})
            ]
    ),

    #"Converted to Table" = Table.FromRecords(
        ProductRecords,
        {
            "ProductID",
            "SKU",
            "ProductName",
            "Attributes"
        },
        MissingField.UseNull
    ),

    #"Expanded Attributes" = Table.ExpandListColumn(
        #"Converted to Table",
        "Attributes"
    ),

    #"Filtered Valid Attributes" = Table.SelectRows(
        #"Expanded Attributes",
        each [Attributes] <> null
    ),

    #"Expanded Attribute Record" = Table.ExpandRecordColumn(
        #"Filtered Valid Attributes",
        "Attributes",
        {
            "Name",
            "Value"
        },
        {
            "Attribute Name",
            "Attribute Value Raw"
        }
    ),

    #"Added Attribute Value" = Table.AddColumn(
        #"Expanded Attribute Record",
        "Attribute Value",
        each
            if [Attribute Value Raw] = null then
                null
            else
                Text.From([Attribute Value Raw]),
        type nullable text
    ),

    #"Added Active Flag" = Table.AddColumn(
        #"Added Attribute Value",
        "Active Flag",
        each
            if [Attribute Name] <> "Active"
                or [Attribute Value] = null
            then
                null
            else
                let
                    Value = Text.Upper(
                        Text.Trim([Attribute Value])
                    )
                in
                    if List.Contains(
                        {"TRUE", "YES", "Y"},
                        Value
                    ) then
                        true
                    else if List.Contains(
                        {"FALSE", "NO", "N"},
                        Value
                    ) then
                        false
                    else
                        null,
        type nullable logical
    ),

    #"Added Warranty Months" = Table.AddColumn(
        #"Added Active Flag",
        "Warranty Months",
        each
            if [Attribute Name] <> "WarrantyMonths"
                or [Attribute Value] = null
            then
                null
            else
                let
                    DigitsOnly = Text.Select(
                        [Attribute Value],
                        {"0".."9"}
                    )
                in
                    try Int64.From(DigitsOnly)
                    otherwise null,
        Int64.Type
    ),

    #"Removed Raw Value" = Table.RemoveColumns(
        #"Added Warranty Months",
        {"Attribute Value Raw"}
    ),

    #"Renamed Columns" = Table.RenameColumns(
        #"Removed Raw Value",
        {
            {"ProductID", "Product ID"},
            {"ProductName", "Product Name"}
        }
    )

in
    #"Renamed Columns"