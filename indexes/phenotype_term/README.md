## Test

```bash
curl -XPOST "https://localhost:9200/phenotype_term/_search?pretty" -H 'Content-Type: application/json' --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD -d '{
    "size": 50,
    "query": {
        "match": {
            "term": { "query": "macrocephaly", "operator": "and"  }
        }
    }
}'
```
