#!/bin/bash
set -xe

REGION='eu-west-1'
AWS_CMD="aws --region=${REGION}"
BUCKET='ecs-demo-terraform-state'
LOCK_TABLE="ecs-demo-locks"
ECR_REPO="nginxdemos/hello"
CLEAN_UP_COMMAND="docker images -q ${ECR_REPO}"

AWS_ACCOUNT_ID="$(aws sts get-caller-identity --output text --query 'Account')"

# S3 Bucket where state file will be saved
${AWS_CMD} s3 ls s3://${BUCKET} &> /dev/null || ${AWS_CMD} s3 mb s3://${BUCKET}
${AWS_CMD} s3api put-bucket-versioning --bucket ${BUCKET} --versioning-configuration Status=Enabled

# State locks are implemented using DynamoDB tables
${AWS_CMD} dynamodb describe-table --table-name ${LOCK_TABLE} &> /dev/null || ${AWS_CMD} dynamodb create-table --table-name ${LOCK_TABLE} --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema KeyType=HASH,AttributeName=LockID --provisioned-throughput WriteCapacityUnits=1,ReadCapacityUnits=1

# Create ECR repository
if ! ${AWS_CMD} ecr describe-repositories --registry-id ${AWS_ACCOUNT_ID} --repository-name ${ECR_REPO}; then
${AWS_CMD} ecr create-repository --repository-name nginxdemos/hello
fi

$(aws ecr get-login --no-include-email --region eu-west-1)
docker pull ${ECR_REPO}
docker tag ${ECR_REPO}:latest ${AWS_ACCOUNT_ID}.dkr.ecr.eu-west-1.amazonaws.com/${ECR_REPO}:latest
docker push ${AWS_ACCOUNT_ID}.dkr.ecr.eu-west-1.amazonaws.com/${ECR_REPO}:latest

# CleanUP
docker rmi -f $(${CLEAN_UP_COMMAND})
