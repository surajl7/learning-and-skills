let
    // Load JSON
    Source = Json.Document(
        File.Contents(
            "C:\MYDATA\TRAINING\REPOSITORIES\learning-and-skills\tool-power-bi\20261001-powerbi-training\assignment-03\data\powerbi_hard_reference_data.json"
        )
    ),

    // Access customers list directly from the JSON record
    Customers = Source[customers],

    // Convert customer records directly into a table
    #"Customers Table" = Table.FromRecords(Customers),

    // Rename columns
    #"Renamed Columns" = Table.RenameColumns(
        #"Customers Table",
        {
            {"CustomerID", "Customer ID"},
            {"CustomerName", "Customer Name"},
            {"Email", "Customer Email"},
            {"Region", "Region"},
            {"Address.City", "City"},
            {"Segment", "Segment"}
        }
    ),

    // Keep required columns
    #"Selected Columns" = Table.SelectColumns(
        #"Renamed Columns",
        {
            "Customer ID",
            "Customer Name",
            "Customer Email",
            "Region",
            "City",
            "Segment"
        }
    ),

    // Trim whitespace
    #"Trimmed Text" = Table.TransformColumns(
        #"Selected Columns",
        {
            {"Customer ID", Text.Trim, type text},
            {"Customer Name", Text.Trim, type text},
            {"Customer Email", Text.Trim, type text},
            {"Region", Text.Trim, type text},
            {"City", Text.Trim, type text},
            {"Segment", Text.Trim, type text}
        }
    ),

    // Standardize text
    #"Standardized Text" = Table.TransformColumns(
        #"Trimmed Text",
        {
            {"Customer Name", Text.Proper, type text},
            {"Customer Email", Text.Lower, type text},
            {"Region", Text.Proper, type text},
            {"City", Text.Proper, type text},
            {"Segment", Text.Proper, type text}
        }
    ),

    // Remove duplicate Customer IDs
    #"Distinct Customers" = Table.Distinct(
        #"Standardized Text",
        {"Customer ID"}
    )

in
    #"Distinct Customers"