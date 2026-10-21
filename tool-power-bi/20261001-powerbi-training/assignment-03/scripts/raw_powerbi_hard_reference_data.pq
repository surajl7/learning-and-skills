let
    Source = Json.Document(
        File.Contents("C:\MYDATA\TRAINING\REPOSITORIES\learning-and-skills\tool-power-bi\20261001-powerbi-training\assignment-03\data\powerbi_hard_reference_data.json")
    ),

    #"Converted to Table" = Table.FromRecords(
        {Source}
    ),

    #"Expanded metadata" = Table.ExpandRecordColumn(
        #"Converted to Table", 
        "metadata", 
        {
            "dataset", 
            "version", 
            "generatedFor", 
            "baseCurrency"
        }, 
        {
            "metadata.dataset", 
            "metadata.version", 
            "metadata.generatedFor", 
            "metadata.baseCurrency"
        }
    ),

    #"Changed Type" = Table.TransformColumnTypes(
        #"Expanded metadata",
        {
            {"metadata.dataset",      type text   },
            {"metadata.version",      type number },
            {"metadata.generatedFor", type text   },
            {"metadata.baseCurrency", type text   },
            {"customers",             type any    },
            {"products",              type any    },
            {"promotions",            type any    },
            {"exchangeRates",         type any    }
        }
    )
in
    #"Changed Type"