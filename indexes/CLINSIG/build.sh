#!/bin/bash

# Log password
echo ${ELASTIC_PASSWORD}

# Prepare data
unzip -o data.zip

# Create index
curl --cacert ../../http_ca.crt -u elastic:${ELASTIC_PASSWORD} -XPUT "https://localhost:9200/clinsig?pretty" -H 'Content-Type: application/json' -d'
{
    "mappings":{
        "properties": {
            "key": {
                "type": "keyword"
            },
            "chrom": {
                "type": "keyword"
            },
            "pos": {
                "type": "integer"
            },
            "ref": {
                "type": "keyword",
                "index": false
            },
            "alt": {
                "type": "keyword",
                "index": false
            },
            "variant_id": {
                "type": "keyword",
                "index": false
            },
            "clinsig": {
                "type": "keyword",
                "index": false
            },
            "clinsig_ch": {
                "type": "keyword",
                "index": false
            }
        }
    }
}'

# Import data
python3 import.py --file data.txt --cacerts ../../http_ca.crt --password ${ELASTIC_PASSWORD}

