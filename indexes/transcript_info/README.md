## Create index

```bash
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD -XPUT "https://localhost:9200/transcript_info?pretty" -H 'Content-Type: application/json' -d'
{
    "mappings":{
        "properties": {
            "gene_name": {
                "type": "keyword"
            },
            "ENSG": {
                "type": "keyword"
            },
            "ENST": {
                "type": "keyword"
            },
            "length": {
                "type": "keyword",
                "index": false
            },
            "transcript": {
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
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD  -XPOST "https://localhost:9200/transcript_info/_search?pretty" -H 'Content-Type: application/json' -d '
{
    "query": {
        "bool": {
            "should": [
                {"match": {"gene_name":  { "query": "SLC25A26", "operator": "and"}}},
                {"match": {"gene_name":  { "query": "HMGA1P6", "operator": "and"}}}
            ]
        }
    },
    "size": 1000000
}'
```
