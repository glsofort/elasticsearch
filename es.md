## Elasticsearch for testing

```bash
docker network create elastic

sudo sysctl -w vm.max_map_count=262144

docker run --rm --memory="4g" --name es01 --net elastic -p 9200:9200 -itd  gls-elasticsearch:8.11.1

docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic --url https://localhost:9200

curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200

docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana

```


```bash
docker network create elastic

docker run --rm --name es02 --net elastic -p 9300:9200 -it  elasticsearch:8.11.1

docker exec -it es02 /usr/share/elasticsearch/bin/elasticsearch-reset-password -u elastic

docker exec -it es01 /usr/share/elasticsearch/bin/elasticsearch-create-enrollment-token -s kibana
```

```bash
curl -XPOST "localhost:9200/hpo_omim_terms/_doc/_search?pretty" -H 'Content-Type: application/json' -d '{"size": 50, "query": { "match": { "term": { "query": "macrocephaly", "operator": "and"  } } }}'

curl -XPOST "localhost:9200/test_chinese_v2/_doc/_search?pretty" -H 'Content-Type: application/json' -d '{"size": 50, "query": { "match": { "term": { "query": "macrocephaly", "operator": "and"  } } }}'



curl -XPUT "http://localhost:9200/test_chinese_v2?pretty" -H 'Content-Type: application/json' -d'
{
    "settings": {
        "index": {
            "analysis": {
                "analyzer": {
                    "smartcn_improve": {
                        "char_filter" : [
                            "dash_punctuation_mapping"
                        ],
                        "tokenizer": "smartcn_tokenizer",
                        "filter": [
                            "lowercase",
                            "edgeNGram_filter"
                        ]
                    }
                },
                "filter": {
                    "edgeNGram_filter" : {
                        "type" : "edge_ngram",
                        "min_gram" : "3",
                        "max_gram" : "20"
                      }
                },
                "char_filter" : {
                    "dash_punctuation_mapping" : {
                      "type" : "mapping",
                      "mappings" : [
                        "- => \\u0020"
                      ]
                    }
                  }
            }
        }
    }
}'

```


✅ Elasticsearch security features have been automatically configured!
✅ Authentication is enabled and cluster connections are encrypted.

ℹ️  Password for the elastic user (reset with `bin/elasticsearch-reset-password -u elastic`):
  $ELASTIC_PASSWORD

ℹ️  HTTP CA certificate SHA-256 fingerprint:
  ffc5fb14a5017d5f917cc575457c956db2bec154ced78da4cea1c839c5e9e4ed

ℹ️  Configure Kibana to use this cluster:
• Run Kibana and click the configuration link in the terminal when Kibana starts.
• Copy the following enrollment token and paste it into Kibana in your browser (valid for the next 30 minutes):
  eyJ2ZXIiOiI4LjExLjEiLCJhZHIiOlsiMTcyLjE4LjAuMjo5MjAwIl0sImZnciI6ImZmYzVmYjE0YTUwMTdkNWY5MTdjYzU3NTQ1N2M5NTZkYjJiZWMxNTRjZWQ3OGRhNGNlYTFjODM5YzVlOWU0ZWQiLCJrZXkiOiJPUnZxSkl3QmFMelA5anFIM2NRZDpWa01mTTB5WVIwT3ZfZXRxbVgtQWtBIn0=

ℹ️ Configure other nodes to join this cluster:
• Copy the following enrollment token and start new Elasticsearch nodes with `bin/elasticsearch --enrollment-token <token>` (valid for the next 30 minutes):
  eyJ2ZXIiOiI4LjExLjEiLCJhZHIiOlsiMTcyLjE4LjAuMjo5MjAwIl0sImZnciI6ImZmYzVmYjE0YTUwMTdkNWY5MTdjYzU3NTQ1N2M5NTZkYjJiZWMxNTRjZWQ3OGRhNGNlYTFjODM5YzVlOWU0ZWQiLCJrZXkiOiJPeHZxSkl3QmFMelA5anFIM2NRZjpsTnpoYU9xd1E5dV9IamkwUnlMU2pnIn0=

  If you're running in Docker, copy the enrollment token and run:
  `docker run -e "ENROLLMENT_TOKEN=<token>" docker.elastic.co/elasticsearch/elasticsearch:8.11.1`

```bash
docker cp es01:/usr/share/elasticsearch/config/certs/http_ca.crt .
```