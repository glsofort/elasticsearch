## Test

```bash
curl --cacert ../../http_ca.crt -u elastic:${ELASTIC_PASSWORD}  -XPOST "https://localhost:9200/gene_clinical_synopsis/_search?pretty" -H 'Content-Type: application/json' -d '
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
                {"match": {"gene_name":  { "query": "COL2A1", "operator": "and"}}}
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