let
    Source = raw_reference_data[promotions],

    #"Converted to Table" = Table.FromRecords(Source),

    #"Changed Types" = Table.TransformColumnTypes(
        #"Converted to Table",
        {
            {"PromotionCode", type text},
            {"PromotionName", type text},
            {"DiscountPct", type number},
            {"ValidFrom", type date},
            {"ValidTo", type date}
        }
    ),

    #"Trimmed Text" = Table.TransformColumns(
        #"Changed Types",
        {
            {"PromotionCode", Text.Trim, type text},
            {"PromotionName", Text.Trim, type text}
        }
    ),

    #"Renamed Columns" = Table.RenameColumns(
        #"Trimmed Text",
        {
            {"PromotionCode", "Promotion Code"},
            {"PromotionName", "Promotion Name"},
            {"DiscountPct", "Discount %"},
            {"ValidFrom", "Valid From"},
            {"ValidTo", "Valid To"}
        }
    ),

    #"Distinct Promotions" = Table.Distinct(
        #"Renamed Columns",
        {"Promotion Code"}
    )

in
    #"Distinct Promotions"
