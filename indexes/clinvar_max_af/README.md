## Create index

```bash
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD -XPUT "https://localhost:9200/clinvar_max_af?pretty" -H 'Content-Type: application/json' -d'
{
    "mappings":{
        "properties": {
            "gene_name": {
                "type": "keyword"
            },
            "max_af": {
                "type": "keyword",
                "index": false
            },
            "max_af_pop": {
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