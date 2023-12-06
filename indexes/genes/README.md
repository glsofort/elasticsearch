## Create index

```bash
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD -XPUT "https://localhost:9200/genes?pretty" -H 'Content-Type: application/json' -d'
{
    "mappings":{
        "properties": {
            "gene_name": {
                "type": "keyword"
            },
            "full_name": {
                "type": "keyword",
                "index": false
            },
            "function": {
                "type": "keyword",
                "index": false
            },
            "GHR_metadata": {
                "type": "keyword",
                "index": false
            },
            "function_ch": {
                "type": "keyword",
                "index": false
            },
            "GHR_metadata_ch": {
                "type": "keyword",
                "index": false
            }
        }
    }
}'
```


## Import

```bash
python3 import.py --file data.txt --cacerts ../../http_ca.crt --password $ELASTIC_PASSWORD
```

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