#!/bin/bash

hgnc_id	approved_symbol	symbol	type
# Create index
curl --cacert ../../http_ca.crt -u elastic:${ELASTIC_PASSWORD} -XPUT "https://localhost:9200/hgnc_symbols?pretty" -H 'Content-Type: application/json' -d'
{
    "mappings":{
        "properties": {
            "hgnc_id": {
                "type": "keyword"
            }
            "approved_symbol": {
                "type": "keyword"
            },
            "symbol": {
                "type": "keyword"
            },
            "symbol_type": {
                "type": "keyword"
            }
        }
    }
}'

# Import
python3 import.py --file data.txt --cacerts ../../http_ca.crt --password ${ELASTIC_PASSWORD}