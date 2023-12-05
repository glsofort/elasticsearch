## Create index

```bash
curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD -XPUT "https://localhost:9200/gene_clinical_synopsis?pretty" -H 'Content-Type: application/json' -d'
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
            "gene_mim_number": {
                "type": "keyword",
                "index": false
            },
            "pheno_mim_number": {
                "type": "keyword",
                "index": false
            },
            "pheno_name": {
                "type": "text",
                "analyzer": "default"
            },
            "clinical_synopsis": {
                "type": "text",
                "analyzer": "default"
            },
            "pheno_description": {
                "type": "keyword",
                "index": false
            },
            "location": {
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
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD  -XPOST "https://localhost:9200/gene_clinical_synopsis/_search?pretty" -H 'Content-Type: application/json' -d '
{ 
    "query": { 
        "bool": { 
            "should": [ 
                {"match": {"pheno_name":  { "query": "abnormal", "operator": "and"}}}, 
                {"match": {"clinical_synopsis":  { "query": "abnormal", "operator": "and"}}},
                {"match": {"pheno_name":  { "query": "对肋骨", "operator": "and"}}}, 
                {"match": {"clinical_synopsis":  { "query": "对肋骨", "operator": "and"}}}
            ] 
        } 
    }, 
    "size": 0, 
    "aggs": { 
        "items": { 
            "terms": {  
                "field": "gene_name.keyword", 
                "size": 1000000,
                "order": { "max_score": "desc" }
            },
            "aggs": {
                "max_score": { "max": { "script": "_score" } }
            }
        }
    } 
}'
```

```bash
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD  -XPOST "https://localhost:9200/gene_clinical_synopsis/_search?pretty" -H 'Content-Type: application/json' -d '
{ 
    "query": { 
        "bool": { 
            "should": [ 
                {"match": {"pheno_name":  { "query": "abnormal", "operator": "and"}}}, 
                {"match": {"clinical_synopsis":  { "query": "abnormal", "operator": "and"}}},
                {"match": {"pheno_name":  { "query": "对肋骨", "operator": "and"}}}, 
                {"match": {"clinical_synopsis":  { "query": "对肋骨", "operator": "and"}}}
            ] 
        } 
    }, 
    "size": 0, 
    "aggs": { 
        "items": { 
            "multi_terms": {
                "terms": [
                    {"field": "gene_name.keyword"},
                    {"field": "pheno_name.keyword"}
                ],
                "size": 1000000,
                "order": { "max_score": "desc" }
            },
            "aggs": {
                "max_score": { "max": { "script": "_score" } }
            }
        }
    } 
}'
```

```bash
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD  -XPOST "https://localhost:9200/gene_clinical_synopsis/_search?pretty" -H 'Content-Type: application/json' -d '
{ 
    "query": { 
        "bool": { 
            "should": [ 
                {"match": {"gene_name":  { "query": "BRCA1", "operator": "and"}}}, 
                {"match": {"clinical_synopsis":  { "query": "COL2A1", "operator": "and"}}}
            ] 
        } 
    }, 
    "size": 0, 
    "aggs": { 
        "items": { 
            "multi_terms": {
                "terms": [
                    {"field": "gene_name.keyword"},
                    {"field": "pheno_name.keyword"}
                ],
                "size": 1000000,
                "order": { "max_score": "desc" }
            },
            "aggs": {
                "max_score": { "max": { "script": "_score" } }
            }
        }
    } 
}'
```