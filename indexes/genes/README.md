## Test

```bash
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD  -XPOST "https://localhost:9200/genes/_search?pretty" -H 'Content-Type: application/json' -d '
{ 
    "query": { 
        "bool": { 
            "should": [ 
                {"match": {"gene_name":  { "query": "BRCA1", "operator": "and"}}}, 
                {"match": {"gene_name":  { "query": "BRCA2", "operator": "and"}}}
            ] 
        } 
    }, 
    "size": 1000000
}'
```