#!/bin/bash

# image_export: registry.cn-shenzhen.aliyuncs.com/gls-production/elasticsearch:8.11.0

docker stop es01

docker build -t build-gls-elasticsearch:8.11.0 .

docker rm es01

docker run --rm --memory="4g" --name es01 --net elastic -p 9200:9200 -itd  build-gls-elasticsearch:8.11.0

docker cp es01:/usr/share/elasticsearch/config/certs/http_ca.crt .

# KT5UcF0I9v0jX0_iC9zh