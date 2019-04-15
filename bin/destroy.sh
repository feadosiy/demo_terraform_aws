#!/bin/bash
set -xe

CONF_PATH="./bin"
SCRIPT_PATH="./live"

# Destroy service
pushd $SCRIPT_PATH/ecs-service
terraform init -upgrade
terraform plan -out plan.out
terraform destroy -auto-approve
rm plan.out
popd

# Destroy ELB
pushd $SCRIPT_PATH/elb
terraform init -upgrade
terraform plan -out plan.out
terraform destroy -auto-approve
rm plan.out
popd

# Destroy ECS
pushd $SCRIPT_PATH/ecs
terraform init -upgrade
terraform plan -out plan.out
terraform destroy -auto-approve
rm plan.out
popd

# Destroy VPC
pushd $SCRIPT_PATH/vpc
terraform init -upgrade
terraform plan -out plan.out
terraform destroy -auto-approve
rm plan.out
popd
