#!/bin/bash

# Create index
curl --cacert ../../http_ca.crt -u elastic:${ELASTIC_PASSWORD} -XPUT "https://localhost:9200/gene_clinical_synopsis?pretty" -H 'Content-Type: application/json' -d'
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
            "gene_name": {
                "type": "keyword"
            },
            "gene_mim_number": {
                "type": "keyword",
                "index": false
            },
            "pheno_mim_number": {
                "type": "keyword"
            },
            "pheno_name": {
                "type": "text",
                "analyzer": "default",
                "fields": {
                    "keyword": { 
                        "type": "keyword"
                    }
                }
            },
            "clinical_synopsis": {
                "type": "text",
                "analyzer": "default",
                "fields": {
                    "keyword": { 
                        "type": "keyword"
                    }
                }
            },
            "pheno_description": {
                "type": "keyword",
                "index": false
            },
            "location": {
                "type": "keyword",
                "index": false
            }
        }
    }
}'

# Import
python3 import.py --file data.txt --cacerts ../../http_ca.crt --password ${ELASTIC_PASSWORD}