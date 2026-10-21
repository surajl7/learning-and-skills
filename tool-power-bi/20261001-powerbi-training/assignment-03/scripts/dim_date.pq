let
    // Reference sales/order table
    Source = fact_sales,

    // Keep only rows having a valid Order ID and Order Date
    #"Valid Orders" = Table.SelectRows(
        Source,
        each
            [Order ID] <> null
            and Text.Trim([Order ID]) <> ""
            and [Order Date] <> null
    ),

    // Get minimum and maximum Order Date
    MinDate = List.Min(
        #"Valid Orders"[Order Date]
    ),

    MaxDate = List.Max(
        #"Valid Orders"[Order Date]
    ),

    // Generate continuous date list
    DateList = List.Dates(
        MinDate,
        Duration.Days(MaxDate - MinDate) + 1,
        #duration(1, 0, 0, 0)
    ),

    // Convert date list into table
    #"Converted to Table" = Table.FromList(
        DateList,
        Splitter.SplitByNothing(),
        {"Date"}
    ),

    #"Changed Type" = Table.TransformColumnTypes(
        #"Converted to Table",
        {
            {"Date", type date}
        }
    ),

    // Date Key
    #"Added Date Key" = Table.AddColumn(
        #"Changed Type",
        "Date Key",
        each
            Date.Year([Date]) * 10000
            + Date.Month([Date]) * 100
            + Date.Day([Date]),
        Int64.Type
    ),

    // Year
    #"Added Year" = Table.AddColumn(
        #"Added Date Key",
        "Year",
        each Date.Year([Date]),
        Int64.Type
    ),

    // Quarter
    #"Added Quarter" = Table.AddColumn(
        #"Added Year",
        "Quarter",
        each "Q" & Text.From(
            Date.QuarterOfYear([Date])
        ),
        type text
    ),

    // Month number
    #"Added Month Number" = Table.AddColumn(
        #"Added Quarter",
        "Month Number",
        each Date.Month([Date]),
        Int64.Type
    ),

    // Month name
    #"Added Month Name" = Table.AddColumn(
        #"Added Month Number",
        "Month",
        each Date.ToText(
            [Date],
            "MMMM"
        ),
        type text
    ),

    // Short month name
    #"Added Month Short" = Table.AddColumn(
        #"Added Month Name",
        "Month Short",
        each Date.ToText(
            [Date],
            "MMM"
        ),
        type text
    ),

    // Year-Month
    #"Added Year Month" = Table.AddColumn(
        #"Added Month Short",
        "Year-Month",
        each Date.ToText(
            [Date],
            "yyyy-MM"
        ),
        type text
    ),

    // Day
    #"Added Day" = Table.AddColumn(
        #"Added Year Month",
        "Day",
        each Date.Day([Date]),
        Int64.Type
    ),

    // Day number, Monday = 1
    #"Added Day of Week" = Table.AddColumn(
        #"Added Day",
        "Day of Week",
        each
            Date.DayOfWeek(
                [Date],
                Day.Monday
            ) + 1,
        Int64.Type
    ),

    // Day name
    #"Added Day Name" = Table.AddColumn(
        #"Added Day of Week",
        "Day Name",
        each Date.ToText(
            [Date],
            "dddd"
        ),
        type text
    )

in
    #"Added Day Name"
