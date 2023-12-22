## Test

```bash
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD  -XPOST "https://localhost:9200/clinsig/_search?pretty" -H 'Content-Type: application/json' -d '
{ 
    "query": { 
        "bool": { 
            "must": [
                {
                    "match": {
                        "chrom": "1"
                    }
                },
                {
                    "match": {
                        "pos": "10003558"
                    }
                }
            ]
        } 
    }, 
    "functions": [
        {
          "exp": {
            "pos": {
              "origin": "10003558",
              "scale": "1"
            }
          }
        }
      ],
    "size": 10
}'
```