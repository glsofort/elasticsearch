#!/bin/bash

# Log password
echo ${ELASTIC_PASSWORD}

# Create index
curl --cacert ../../http_ca.crt -u elastic:${ELASTIC_PASSWORD} -XPUT "https://localhost:9200/transcript_info?pretty" -H 'Content-Type: application/json' -d'
{
    "mappings":{
        "properties": {
            "gene_name": {
                "type": "keyword"
            },
            "ENSG": {
                "type": "keyword"
            },
            "ENST": {
                "type": "keyword"
            },
            "length": {
                "type": "keyword",
                "index": false
            },
            "transcript": {
                "type": "keyword",
                "index": false
            }
        }
    }
}'

# Import
python3 import.py --file data.txt --cacerts ../../http_ca.crt --password ${ELASTIC_PASSWORD}
