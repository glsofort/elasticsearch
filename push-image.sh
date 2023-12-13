#!/bin/bash

docker commit es01 registry.cn-shenzhen.aliyuncs.com/gls-production/elasticsearch:8.11.1

docker push registry.cn-shenzhen.aliyuncs.com/gls-production/elasticsearch:8.11.1