let
    // Get products list from the raw JSON
    Products = raw_reference_data[products],

    // Reusable function to find an attribute value by attribute name
    GetAttributeValue = (
        Attributes as any,
        AttributeName as text
    ) as any =>
        let
            AttributeList =
                if Attributes is list then
                    Attributes
                else
                    {},

            MatchingAttributes = List.Select(
                AttributeList,
                each
                    Record.FieldOrDefault(_, "Name", null)
                        = AttributeName
            ),

            AttributeValue =
                if List.IsEmpty(MatchingAttributes) then
                    null
                else
                    Record.FieldOrDefault(MatchingAttributes{0},"Value",null)
        in
            AttributeValue,

    // Create one record per product
    ProductAttributeRecords = List.Transform(
        Products,
        each
            let
                ProductRecord = _,

                Attributes = Record.FieldOrDefault(
                    ProductRecord,
                    "Attributes",
                    {}
                ),

                WarrantyRaw = GetAttributeValue(
                    Attributes,
                    "WarrantyMonths"
                ),

                ActiveRaw = GetAttributeValue(
                    Attributes,
                    "Active"
                ),

                WarrantyText =
                    if WarrantyRaw = null then
                        null
                    else
                        Text.From(WarrantyRaw),

                WarrantyDigits =
                    if WarrantyText = null then
                        null
                    else
                        Text.Select(
                            WarrantyText,
                            {"0".."9"}
                        ),

                WarrantyMonths =
                    if WarrantyDigits = null
                        or WarrantyDigits = ""
                    then
                        null
                    else
                        try Int64.From(WarrantyDigits)
                        otherwise null,

                ActiveText =
                    if ActiveRaw = null then
                        null
                    else
                        Text.Upper(
                            Text.Trim(
                                Text.From(ActiveRaw)
                            )
                        ),

                ActiveStatus =
                    if List.Contains(
                        {"TRUE", "YES", "Y"},
                        ActiveText
                    ) then
                        true
                    else if List.Contains(
                        {"FALSE", "NO", "N"},
                        ActiveText
                    ) then
                        false
                    else
                        null
            in
                [
                    ProductID = Record.FieldOrDefault(
                        ProductRecord,
                        "ProductID",
                        null
                    ),

                    SKU = Record.FieldOrDefault(
                        ProductRecord,
                        "SKU",
                        null
                    ),

                    ProductName = Record.FieldOrDefault(
                        ProductRecord,
                        "ProductName",
                        null
                    ),

                    WarrantyMonths = WarrantyMonths,
                    ActiveStatus = ActiveStatus
                ]
    ),

    // Convert the records to a table
    #"Converted to Table" = Table.FromRecords(
        ProductAttributeRecords,
        {
            "ProductID",
            "SKU",
            "ProductName",
            "WarrantyMonths",
            "ActiveStatus"
        },
        MissingField.UseNull
    ),

    // Rename columns
    #"Renamed Columns" = Table.RenameColumns(
        #"Converted to Table",
        {
            {"ProductID", "Product ID"},
            {"ProductName", "Product Name"},
            {"WarrantyMonths", "Warranty Months"},
            {"ActiveStatus", "Active Status"}
        }
    ),

    // Apply final data types
    #"Changed Types" = Table.TransformColumnTypes(
        #"Renamed Columns",
        {
            {"Product ID", type text},
            {"SKU", type text},
            {"Product Name", type text},
            {"Warranty Months", Int64.Type},
            {"Active Status", type logical}
        }
    ),

    // Remove duplicate product rows if present
    #"Distinct Products" = Table.Distinct(
        #"Changed Types",
        {"Product ID"}
    )

in
    #"Distinct Products"