# GLS Elasticsearch

## Common Command

### View all indexes
```bash
curl http://localhost:9200/_cat/indices

curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200/_cat/indices
```

### View index information
```bash
curl -H 'Content-Type: application/json' -X GET https://localhost:9200/phenotype_term?pretty

curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD -H 'Content-Type: application/json' -X GET https://localhost:9200/phenotype_term?pretty
```

### View index settings
```bash
curl -X GET "localhost:9200/hpo_omim_terms/_settings?pretty"

curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200/hpo_omim_terms/_settings?pretty
```

### Remove index
```bash
curl -XDELETE "localhost:9200/phenotype_term"

curl  -XDELETE --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200/phenotype_term
```

## Import data

### Import
```bash
export ELASTIC_PASSWORD="nPmsyAyrh3yVt_Q7iNlR"

python3 gene-terms/import.py --file data/gene_clinical_synopsis.txt --cacerts http_ca.crt --password $ELASTIC_PASSWORD
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

### Example with running elasticsearch in docker
```bash
curl --cacert http_ca.crt -u elastic:nPmsyAyrh3yVt_Q7iNlR https://localhost:9200
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
curl -X GET "localhost:9200/my-index-000001/_search?from=40&size=20&pretty" -H 'Content-Type: application/json' -d'
{
  "query": {
    "term": {
      "user.id": "kimchy"
    }
  }
}
'


## Examples
```bash
curl -X GET "localhost:9200/gene_hpo_term/_search?pretty" -H 'Content-Type: application/json' -d '
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
