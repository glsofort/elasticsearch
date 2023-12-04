## Create index

```bash
curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD -XPUT "https://localhost:9200/gene_phenotype?pretty" -H 'Content-Type: application/json' -d'
{
    "settings": {
        "analysis" : {
            "analyzer" : {
                "default" : {
                    "type" : "smartcn"
                }
            }
        }
    },
    "mappings":{
        "properties": {
            "gene_name": {
                "type": "keyword"
            },
            "clinical_synopsis": {
                "type": "text",
                "analyzer": "default"
            },
            "name": {
                "type": "text",
                "analyzer": "default"
            }
        }
    }
}'
```


## Import

```bash
python3 import.py --file data.txt --cacerts ../../http_ca.crt --password $ELASTIC_PASSWORD
```