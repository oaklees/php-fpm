#!/usr/bin/env bash

ECR_REGISTRY="${ECR_REGISTRY:-959744386191.dkr.ecr.eu-west-1.amazonaws.com}"
ECR_REPOSITORY="${ECR_REPOSITORY:-podpoint/php-fpm}"

docker build --tag ${ECR_REGISTRY}/${ECR_REPOSITORY}:7.1-cli ./cli
docker build --tag ${ECR_REGISTRY}/${ECR_REPOSITORY}:7.1-fpm ./fpm
docker build --tag ${ECR_REGISTRY}/${ECR_REPOSITORY}:7.1 .

docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:7.1-cli
docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:7.1-fpm
docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:7.1
