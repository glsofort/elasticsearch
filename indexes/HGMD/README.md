## Create index

```bash
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD -XPUT "https://localhost:9200/hgmd?pretty" -H 'Content-Type: application/json' -d'
{
    "mappings":{
        "properties": {
            "key": {
                "type": "keyword"
            },
            "chrom": {
                "type": "keyword",
                "index": false
            },
            "pos": {
                "type": "keyword",
                "index": false
            },
            "ref": {
                "type": "keyword",
                "index": false
            },
            "alt": {
                "type": "keyword",
                "index": false
            },
            "info": {
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