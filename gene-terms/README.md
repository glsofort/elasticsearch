

## Create index

### Create index for english version
```bash
curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD -XPUT "https://localhost:9200/gene_terms?pretty" -H 'Content-Type: application/json' -d'
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
            "term": {
                "type": "text",
                "analyzer": "default"
            },
            "gene_name": {
                "type": "keyword"
            },
            "omim_id": {
                "type": "keyword",
                "index": false
            },
            "source": {
                "type": "keyword",
                "index": false
            },
            "gene_id": {
                "type": "keyword",
                "index": false
            },
            "hpo_id": {
                "type": "keyword",
                "index": false
            },
            "english_term": {
                "type": "keyword",
                "index": false
            }
        }
    }
}'
```

### Create index for chinese version
```bash
curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD -XPUT "https://localhost:9200/gene_terms?pretty" -H 'Content-Type: application/json' -d'
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
            "term": {
                "type": "text",
                "analyzer": "default"
            },
            "gene_name": {
                "type": "keyword"
            },
            "omim_id": {
                "type": "keyword",
                "index": false
            },
            "source": {
                "type": "keyword",
                "index": false
            },
            "gene_id": {
                "type": "keyword",
                "index": false
            },
            "hpo_id": {
                "type": "keyword",
                "index": false
            },
            "english_term": {
                "type": "keyword",
                "index": false
            }
        }
    }
}'
```

## Import

### Import english version
```bash
python3 import.py --file data/gene_phenotype.en.txt --cacerts ../http_ca.crt --name gene_terms_en --password $ELASTIC_PASSWORD
```

### Import chinese version
```bash
python3 import.py --file data/gene_phenotype.cn.txt --cacerts ../http_ca.crt --name gene_terms_cn --password $ELASTIC_PASSWORD
```