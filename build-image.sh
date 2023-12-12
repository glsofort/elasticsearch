#!/bin/bash

docker build -t registry.cn-shenzhen.aliyuncs.com/gls-production/elasticsearch:1.0.0 .

docker run --rm --memory="4g" --name es01 --net elastic -p 9200:9200 -itd  gls-elasticsearch:8.11.1

docker cp es01:/usr/share/elasticsearch/config/certs/http_ca.crt .
