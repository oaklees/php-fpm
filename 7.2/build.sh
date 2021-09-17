#!/usr/bin/env bash

ECR_REGISTRY="${ECR_REGISTRY:-959744386191.dkr.ecr.eu-west-1.amazonaws.com}"
ECR_REPOSITORY="${ECR_REPOSITORY:-podpoint/php-fpm}"

docker build --tag ${ECR_REGISTRY}/${ECR_REPOSITORY}:7.2-cli ./cli
docker build --tag ${ECR_REGISTRY}/${ECR_REPOSITORY}:7.2-fpm ./fpm
docker build --tag ${ECR_REGISTRY}/${ECR_REPOSITORY}:7.2 .

docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:7.2-cli
docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:7.2-fpm
docker push ${ECR_REGISTRY}/${ECR_REPOSITORY}:7.2
