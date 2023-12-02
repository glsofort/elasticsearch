#!/bin/bash

curl --cacert http_ca.crt -u elastic:S_sGMe5dG8wV12lvUh0Z -XPUT "https://localhost:9200/gene_terms?pretty" -H 'Content-Type: application/json' -d'
{
    "settings": {
        "analysis" : {
            "analyzer" : {
                "default" : {
                    "type" : "smartcn"
                }
            }
        }
    },
    "mappings":{
        "properties": {
            "term": {
                "type": "text",
                "analyzer": "default"
            },
            "gene_name": {
                "type": "keyword"
            },
            "omim_id": {
                "type": "keyword",
                "index": false
            },
            "source": {
                "type": "keyword",
                "index": false
            },
            "gene_id": {
                "type": "keyword",
                "index": false
            },
            "hpo_id": {
                "type": "keyword",
                "index": false
            },
            "english_term": {
                "type": "keyword",
                "index": false
            }
        }
    }
}'
