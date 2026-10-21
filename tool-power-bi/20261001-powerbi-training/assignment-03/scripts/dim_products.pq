let
    // Get product records from the raw JSON
    ProductRecords = raw_reference_data[products],

    // Add missing fields with null defaults
    // Existing product values override these defaults
    NormalizedProductRecords = List.Transform(
        ProductRecords,
        each
            Record.Combine(
                {
                    [
                        ProductID = null,
                        SKU = null,
                        ProductName = null,
                        Category = null,
                        Subcategory = null,
                        ListPrice = null,
                        Brand = null,
                        Pricing = null,
                        Supplier = null,
                        Attributes = null
                    ],
                    _
                }
            )
    ),

    // Convert normalized records into a table
    #"Converted to Table" = Table.FromRecords(
        NormalizedProductRecords,
        {
            "ProductID",
            "SKU",
            "ProductName",
            "Category",
            "Subcategory",
            "ListPrice",
            "Brand",
            "Pricing",
            "Supplier",
            "Attributes"
        },
        MissingField.UseNull
    ),

    // Safely read nested Pricing fields
    #"Added Pricing List Price" = Table.AddColumn(
        #"Converted to Table",
        "Pricing List Price",
        each
            if [Pricing] = null then
                null
            else
                Record.FieldOrDefault(
                    [Pricing],
                    "ListPrice",
                    null
                ),
        type any
    ),

    #"Added Standard Cost" = Table.AddColumn(
        #"Added Pricing List Price",
        "Standard Cost",
        each
            if [Pricing] = null then
                null
            else
                Record.FieldOrDefault(
                    [Pricing],
                    "StandardCost",
                    null
                ),
        type any
    ),

    #"Added Currency" = Table.AddColumn(
        #"Added Standard Cost",
        "Currency",
        each
            if [Pricing] = null then
                null
            else
                Record.FieldOrDefault(
                    [Pricing],
                    "Currency",
                    null
                ),
        type nullable text
    ),

    // Safely read nested Supplier fields
    #"Added Supplier ID" = Table.AddColumn(
        #"Added Currency",
        "Supplier ID",
        each
            if [Supplier] = null then
                null
            else
                Record.FieldOrDefault(
                    [Supplier],
                    "SupplierID",
                    null
                ),
        type nullable text
    ),

    #"Added Supplier Name" = Table.AddColumn(
        #"Added Supplier ID",
        "Supplier Name",
        each
            if [Supplier] = null then
                null
            else
                Record.FieldOrDefault(
                    [Supplier],
                    "SupplierName",
                    null
                ),
        type nullable text
    ),

    // Use nested Pricing.ListPrice as the authoritative list price
    // Invalid values such as "N/A" become null
    #"Converted Numeric Values" = Table.TransformColumns(
        #"Added Supplier Name",
        {
            {
                "Pricing List Price",
                each try Number.From(_) otherwise null,
                type nullable number
            },
            {
                "Standard Cost",
                each try Number.From(_) otherwise null,
                type nullable number
            }
        }
    ),

    // Remove fields not required in the Products table
    #"Removed Nested Columns" = Table.RemoveColumns(
        #"Converted Numeric Values",
        {
            "ListPrice",
            "Pricing",
            "Supplier",
            "Attributes"
        },
        MissingField.Ignore
    ),

    // Trim text safely
    TextColumns = {
        "ProductID",
        "SKU",
        "ProductName",
        "Category",
        "Subcategory",
        "Brand",
        "Currency",
        "Supplier ID",
        "Supplier Name"
    },

    #"Trimmed Text" = Table.TransformColumns(
        #"Removed Nested Columns",
        List.Transform(
            TextColumns,
            each
                {
                    _,
                    (value) =>
                        if value = null then
                            null
                        else
                            Text.Trim(Text.From(value)),
                    type nullable text
                }
        )
    ),

    #"Renamed Columns" = Table.RenameColumns(
        #"Trimmed Text",
        {
            {"ProductID", "Product ID"},
            {"ProductName", "Product Name"},
            {"Pricing List Price", "List Price"}
        }
    ),

    #"Distinct Products" = Table.Distinct(
        #"Renamed Columns",
        {"Product ID"}
    )

in
    #"Distinct Products"