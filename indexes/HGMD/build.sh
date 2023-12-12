#!/bin/bash

# Log password
echo ${ELASTIC_PASSWORD}

# Create index
curl --cacert ../../http_ca.crt -u elastic:${ELASTIC_PASSWORD} -XPUT "https://localhost:9200/hgmd?pretty" -H 'Content-Type: application/json' -d'
{
    "mappings":{
        "properties": {
            "key": {
                "type": "keyword"
            },
            "chrom": {
                "type": "keyword",
                "index": false
            },
            "pos": {
                "type": "keyword",
                "index": false
            },
            "ref": {
                "type": "keyword",
                "index": false
            },
            "alt": {
                "type": "keyword",
                "index": false
            },
            "info": {
                "type": "keyword",
                "index": false
            }
        }
    }
}'

# Import 
python3 import.py --file data.txt --cacerts ../../http_ca.crt --password ${ELASTIC_PASSWORD}