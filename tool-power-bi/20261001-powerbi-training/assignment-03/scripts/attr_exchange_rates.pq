let
    Source = raw_reference_data[exchangeRates],

    #"Converted to Table" = Table.FromRecords(Source),

    #"Changed Types" = Table.TransformColumnTypes(
        #"Converted to Table",
        {
            {"currency", type text},
            {"rateToINR", type number},
            {"effectiveDate", type date}
        }
    ),

    #"Standardized Currency" = Table.TransformColumns(
        #"Changed Types",
        {
            {
                "currency",
                each
                    if _ = null then
                        null
                    else
                        Text.Upper(Text.Trim(_)),
                type nullable text
            }
        }
    ),

    #"Renamed Columns" = Table.RenameColumns(
        #"Standardized Currency",
        {
            {"currency", "Currency"},
            {"rateToINR", "Rate to INR"},
            {"effectiveDate", "Effective Date"}
        }
    ),

    #"Distinct Exchange Rates" = Table.Distinct(
        #"Renamed Columns",
        {
            "Currency",
            "Effective Date"
        }
    )

in
    #"Distinct Exchange Rates"