## Test

```bash
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD  -XPOST "https://localhost:9200/clinvar_max_af/_search?pretty" -H 'Content-Type: application/json' -d '
{ 
    "query": { 
        "bool": { 
            "should": [ 
                {"match": {"gene_name":  { "query": "CASR", "operator": "and"}}}, 
                {"match": {"gene_name":  { "query": "MSH3", "operator": "and"}}}
            ] 
        } 
    }, 
    "size": 1000000
}'
```