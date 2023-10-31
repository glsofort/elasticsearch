# GLS Elasticsearch

## Import data

### Import Gene - Clinical Synopsis
```bash
python3 import.py --index gene_clinical_synopsis --file data/gene_clinical_synopsis.txt
```

### Import Gene - HPO
```bash
python3 import_hpo.py --index gene_hpo_term --file data/gene_hpo.txt
```

## Elasticsearch creation

### Update some settings
```bash
curl -X PUT "localhost:9200/_settings"  -H 'Content-Type: application/json' -d'
{
    "index.max_result_window": 1000000
}'
```

### Index: gene_clinical_synopsis
```bash
curl -XPUT "http://localhost:9200/gene_clinical_synopsis?pretty" -H 'Content-Type: application/json' -d'
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
            "clinical_synopsis": {
                "type": "text",
                "analyzer": "default"
            },
            "gene_name": {
                "type": "keyword"
            },
            "name": {
                "type": "text"
            }
        }
    }
}'
```

### Index: gene_hpo_term
``` bash
curl -XPUT "http://localhost:9200/gene_hpo_term?pretty" -H 'Content-Type: application/json' -d'
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
            }
       }
  }
}'
```

## Examples
```bash
curl -X GET "localhost:9200/gene_hpo_term/_doc/_search?pretty" -H 'Content-Type: application/json' -d '
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
                "field": "gene_name", 
                "size": 1000000 
            } 
        }
    } 
}'
```
