## Test

```bash
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD  -XPOST "https://localhost:9200/hgmd/_search?pretty" -H 'Content-Type: application/json' -d '
{ 
    "query": { 
        "bool": { 
            "should": [ 
                {"match": {"key":  { "query": "1_877523_C_G", "operator": "and"}}}, 
                {"match": {"key":  { "query": "1_976962_C_T", "operator": "and"}}}
            ] 
        } 
    }, 
    "size": 1000000
}'
```