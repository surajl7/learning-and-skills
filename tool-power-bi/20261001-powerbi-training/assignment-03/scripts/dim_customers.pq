let
    Source = raw_reference_data[customers],

    #"Converted to Table" = Table.FromRecords(Source),

    // Expand nested Address record
    #"Expanded Address" = Table.ExpandRecordColumn(
        #"Converted to Table",
        "Address",
        {
            "City",
            "StateCode",
            "Country",
            "PostalCode"
        },
        {
            "City",
            "State Code",
            "Country",
            "Postal Code"
        }
    ),

    // Expand nested Preferences record
    #"Expanded Preferences" = Table.ExpandRecordColumn(
        #"Expanded Address",
        "Preferences",
        {
            "PreferredChannel",
            "OptInEmail",
            "Languages"
        },
        {
            "Preferred Channel",
            "Opt In Email Raw",
            "Languages"
        }
    ),

    // Convert Languages list to comma-separated text
    #"Combined Languages" = Table.TransformColumns(
        #"Expanded Preferences",
        {
            {
                "Languages",
                each
                    if _ = null then
                        null
                    else
                        Text.Combine(
                            List.Transform(_, each Text.From(_)),
                            ", "
                        ),
                type nullable text
            }
        }
    ),

    // Normalize Y, N, true and false into one logical column
    #"Added Opt In Email" = Table.AddColumn(
        #"Combined Languages",
        "Opt In Email",
        each
            let
                Value =
                    if [Opt In Email Raw] = null then
                        null
                    else
                        Text.Upper(
                            Text.Trim(
                                Text.From([Opt In Email Raw])
                            )
                        )
            in
                if List.Contains({"TRUE", "Y", "YES"}, Value) then
                    true
                else if List.Contains({"FALSE", "N", "NO"}, Value) then
                    false
                else
                    null,
        type nullable logical
    ),

    #"Removed Raw Opt In Column" = Table.RemoveColumns(
        #"Added Opt In Email",
        {"Opt In Email Raw"}
    ),

    // Clean text columns
    TextColumns = {
        "CustomerID",
        "CustomerName",
        "Email",
        "Segment",
        "Region",
        "LoyaltyTier",
        "City",
        "State Code",
        "Country",
        "Postal Code",
        "Preferred Channel",
        "Languages"
    },

    #"Trimmed Text" = Table.TransformColumns(
        #"Removed Raw Opt In Column",
        List.Transform(
            TextColumns,
            each {
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

    #"Standardized Email" = Table.TransformColumns(
        #"Trimmed Text",
        {
            {
                "Email",
                each
                    if _ = null then
                        null
                    else
                        Text.Lower(_),
                type nullable text
            }
        }
    ),

    // JoinDate is already in ISO yyyy-MM-dd format
    #"Changed Types" = Table.TransformColumnTypes(
        #"Standardized Email",
        {
            {"CustomerID", type text},
            {"CustomerName", type text},
            {"Email", type text},
            {"Segment", type text},
            {"Region", type text},
            {"JoinDate", type date},
            {"LoyaltyTier", type text},
            {"City", type text},
            {"State Code", type text},
            {"Country", type text},
            {"Postal Code", type text},
            {"Preferred Channel", type text},
            {"Languages", type text},
            {"Opt In Email", type logical}
        }
    ),

    #"Renamed Columns" = Table.RenameColumns(
        #"Changed Types",
        {
            {"CustomerID", "Customer ID"},
            {"CustomerName", "Customer Name"},
            {"JoinDate", "Join Date"},
            {"LoyaltyTier", "Loyalty Tier"}
        }
    ),

    // Remove the repeated C0005 record after cleaning
    #"Distinct Customers" = Table.Distinct(
        #"Renamed Columns",
        {"Customer ID"}
    )

in
    #"Distinct Customers"