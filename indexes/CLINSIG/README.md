## Test

```bash
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD  -XPOST "https://localhost:9200/clinsig/_search?pretty" -H 'Content-Type: application/json' -d '
{ 
    "query": { 
        "bool": { 
            "should": [ 
                {"match": {"key":  { "query": "1_10003558_G_A", "operator": "and"}}}, 
                {"match": {"key":  { "query": "1_100133290_C_A", "operator": "and"}}}
            ] 
        } 
    }, 
    "size": 1000000
}'
```