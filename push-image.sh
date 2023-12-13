#!/bin/bash

docker commit es01 registry.cn-shenzhen.aliyuncs.com/gls-production/elasticsearch:8.11.0

docker push registry.cn-shenzhen.aliyuncs.com/gls-production/elasticsearch:8.11.0