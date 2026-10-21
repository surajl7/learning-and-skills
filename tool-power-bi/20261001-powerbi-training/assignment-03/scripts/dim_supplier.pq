let
    // Access the products list from the base JSON query
    Products = raw_reference_data[products],

    // Extract only the Supplier record from each product
    // Record.FieldOrDefault safely handles missing Supplier fields
    SupplierRecords = List.Transform(
        Products,
        each Record.FieldOrDefault(_, "Supplier", null)
    ),

    // Remove null suppliers, such as Product ID P999
    NonNullSuppliers = List.RemoveNulls(
        SupplierRecords
    ),

    // Convert supplier records into a table
    #"Converted to Table" = Table.FromRecords(
        NonNullSuppliers,
        {
            "SupplierID",
            "SupplierName"
        },
        MissingField.UseNull
    ),

    // Rename supplier columns
    #"Renamed Columns" = Table.RenameColumns(
        #"Converted to Table",
        {
            {"SupplierID", "Supplier ID"},
            {"SupplierName", "Supplier Name"}
        }
    ),

    // Trim supplier values safely
    #"Trimmed Text" = Table.TransformColumns(
        #"Renamed Columns",
        {
            {
                "Supplier ID",
                each
                    if _ = null then
                        null
                    else
                        Text.Trim(Text.From(_)),
                type nullable text
            },
            {
                "Supplier Name",
                each
                    if _ = null then
                        null
                    else
                        Text.Trim(Text.From(_)),
                type nullable text
            }
        }
    ),

    // Remove rows where Supplier ID is missing
    #"Filtered Valid Suppliers" = Table.SelectRows(
        #"Trimmed Text",
        each [Supplier ID] <> null
            and [Supplier ID] <> ""
    ),

    // Keep unique Supplier ID and Supplier Name combinations
    #"Distinct Suppliers" = Table.Distinct(
        #"Filtered Valid Suppliers",
        {
            "Supplier ID",
            "Supplier Name"
        }
    ),

    // Sort for easier review
    #"Sorted Suppliers" = Table.Sort(
        #"Distinct Suppliers",
        {
            {"Supplier ID", Order.Ascending},
            {"Supplier Name", Order.Ascending}
        }
    )

in
    #"Sorted Suppliers"