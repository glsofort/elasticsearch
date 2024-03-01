
## Prepare

```bash
less hgnc_genes.tsv | awk -F"\t" '{ if(FNR==1){ print "hgnc_id\tapproved_symbol\tsymbol\ttype"; } else { split($1,ids,":"); id = ids[2]; if ($4 != ""){ split($4, a, ", "); for(i in a){print id"\t"$2"\t"a[i]"\tprevious"} } if ($5 != "") { split($5, b, ", "); for (i in b){print id"\t"$2"\t"b[i]"\talias" } } } }' > data.txt
```

## Test

```bash
curl --cacert ../../http_ca.crt -u elastic:$ELASTIC_PASSWORD  -XPOST "https://localhost:9200/hgnc_symbols/_search?pretty" -H 'Content-Type: application/json' -d '
{ 
    "query": { 
        "bool": { 
            "should": [ 
                {"match": {"symbol":  { "query": "GBA", "operator": "and"}}}, 
                {"match": {"symbol":  { "query": "A1BG-AS", "operator": "and"}}}
            ] 
        } 
    }, 
    "size": 1000000
}'
```