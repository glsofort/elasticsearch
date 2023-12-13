#!/bin/bash

# Log password
echo ${ELASTIC_PASSWORD}

# Prepare data
unzip -o data.zip

# Create index
curl --cacert ../../http_ca.crt -u elastic:${ELASTIC_PASSWORD} -XPUT "https://localhost:9200/gene_phenotype?pretty" -H 'Content-Type: application/json' -d'
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
            "disease_id": {
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
            "HPO_id": {
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

# Import
python3 import.py --file data.txt --cacerts ../../http_ca.crt --password ${ELASTIC_PASSWORD}