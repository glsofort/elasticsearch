#!/bin/bash

# Create index
curl --cacert ../../http_ca.crt -u elastic:${ELASTIC_PASSWORD} -XPUT "https://localhost:9200/genes?pretty" -H 'Content-Type: application/json' -d'
{
    "mappings":{
        "properties": {
            "transcript": {
                "type": "keyword",
                "index": false
            },
            "gene_name": {
                "type": "keyword"
            },
            "chr": {
                "type": "keyword",
                "index": false
            },
            "n_exons": {
                "type": "keyword",
                "index": false
            },
            "tx_start": {
                "type": "keyword",
                "index": false
            },
            "tx_end": {
                "type": "keyword",
                "index": false
            },
            "bp": {
                "type": "keyword",
                "index": false
            },
            "mu_syn": {
                "type": "keyword",
                "index": false
            },
            "mu_mis": {
                "type": "keyword",
                "index": false
            },
            "mu_lof": {
                "type": "keyword",
                "index": false
            },
            "n_syn": {
                "type": "keyword",
                "index": false
            },
            "n_mis": {
                "type": "keyword",
                "index": false
            },
            "n_lof": {
                "type": "keyword",
                "index": false
            },
            "exp_syn": {
                "type": "keyword",
                "index": false
            },
            "exp_lof": {
                "type": "keyword",
                "index": false
            },
            "syn_z": {
                "type": "keyword",
                "index": false
            },
            "mis_z": {
                "type": "keyword",
                "index": false
            },
            "lof_z": {
                "type": "keyword",
                "index": false
            },
            "pLI": {
                "type": "keyword",
                "index": false
            }
        }
    }
}'

# Import
python3 import.py --file data.txt --cacerts ../../http_ca.crt --password ${ELASTIC_PASSWORD}