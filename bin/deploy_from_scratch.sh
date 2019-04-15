#!/bin/bash
set -xe

CONF_PATH="./bin"
SCRIPT_PATH="./live"

# Create backend, lock tables and ECR repo

pushd $CONF_PATH
./init.sh

# Create VPC and network
pushd ../$SCRIPT_PATH/vpc
terraform init -upgrade
terraform plan -out plan.out
terraform apply plan.out
rm plan.out
popd

# Create  ECS cluster
pushd ../$SCRIPT_PATH/ecs
terraform init -upgrade
terraform plan -out plan.out
terraform apply plan.out
rm plan.out
popd

# Create Load Balancer
pushd ../$SCRIPT_PATH/elb
terraform init -upgrade
terraform plan -out plan.out
terraform apply plan.out
rm plan.out
popd


# Create and deploy service
pushd ../$SCRIPT_PATH/ecs-service
terraform init -upgrade
terraform plan -out plan.out
terraform apply plan.out
rm plan.out
popd