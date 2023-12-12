#!/bin/bash

# Log password
echo ${ELASTIC_PASSWORD}

# Create index
curl --cacert ../../http_ca.crt -u elastic:${ELASTIC_PASSWORD} -XPUT "https://localhost:9200/phenotype_term?pretty" -H 'Content-Type: application/json' -d'
{
    "settings": {
        "analysis" : {
            "filter" : {
                "edgeNGram_filter" : {
                    "type" : "edge_ngram",
                    "min_gram" : "3",
                    "max_gram" : "20"
                }
            },
            "analyzer" : {
                "edgeNGram_analyzer" : {
                    "filter" : [
                        "lowercase",
                        "edgeNGram_filter"
                    ],
                    "char_filter" : [
                        "dash_punctuation_mapping"
                    ],
                    "type" : "custom",
                    "tokenizer" : "whitespace"
                }
            },
            "char_filter" : {
                "dash_punctuation_mapping" : {
                    "type" : "mapping",
                    "mappings" : [
                        "- => \\u0020"
                    ]
                }
            }
        }
    },
    "mappings":{
        "properties": {
            "term": {
                "type": "text",
                "analyzer": "edgeNGram_analyzer"
            }
        }
    }
}'

# Import
python3 import.py --file data.txt --cacerts ../../http_ca.crt --password ${ELASTIC_PASSWORD}