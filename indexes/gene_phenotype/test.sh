#!/bin/bash

curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD  -XPOST "https://localhost:9200/gene_phenotype/_search?pretty" -H 'Content-Type: application/json' -d '
{ 
    "query": { 
        "bool": { 
            "should": [ 
                {"match": {"term":  { "query": "abnormal", "operator": "and"}}}, 
                {"match": {"term":  { "query": "对肋骨", "operator": "and"}}} 
            ] 
        } 
    }, 
    "size": 0, 
    "aggs": { 
        "items": { 
            "multi_terms": {
                "terms": [{ "field": "gene_name.keyword" }, { "field": "term.keyword" }],
                "size": 60000
            }
        }
    }
}'