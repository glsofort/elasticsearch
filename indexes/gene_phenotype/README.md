

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
            "term": {
                "type": "text",
                "analyzer": "default"
            },
            "gene_name": {
                "type": "keyword"
            },
            "disease_id": {
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
            "HPO_id": {
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

```bash
python3 import.py --file data.txt --cacerts ../../http_ca.crt --password $ELASTIC_PASSWORD
```

## Test

```bash
curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD  -XPOST "https://localhost:9200/gene_phenotype/_search?pretty" -H 'Content-Type: application/json' -d '
{ 
    "query": { 
        "bool": { 
            "should": [ 
                {"match": {"term":  { "query": "abnormal", "operator": "and"}}}, 
                {"match": {"term":  { "query": "对肋骨", "operator": "and"}}} 
            ] 
        } 
    }, 
    "size": 0, 
    "aggs": { 
        "genes": { 
            "terms": {  
                "field": "gene_name.keyword", 
                "size": 1000000 
            } 
        }
    } 
}'
```

```bash
curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD  -XPOST "https://localhost:9200/gene_phenotype/_search?pretty" -H 'Content-Type: application/json' -d '
{ 
    "query": { 
        "bool": { 
            "should": [ 
                {"match": {"term":  { "query": "abnormal", "operator": "and"}}}, 
                {"match": {"term":  { "query": "对肋骨", "operator": "and"}}} 
            ] 
        } 
    }, 
    "size": 0, 
    "aggs": { 
        "genes": { 
            "terms": {  
                "field": "gene_name.keyword", 
                "size": 1000000 
            } 
        }
    } 
}'
```
