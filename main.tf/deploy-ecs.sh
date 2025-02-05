#!/bin/bash

# Variables
CLUSTER_NAME="interstellar-cluster"
SERVICE_NAME="interstellar-service"
TASK_DEFINITION="interstellar-task:1"
SUBNET_ID="subnet-00e47d9c39cfaeaf3"  
SECURITY_GROUP_ID="sg-07c8c59647ab697f1"
AWS_REGION="us-east-1"

# Create ECS Service
aws ecs create-service \
  --cluster $CLUSTER_NAME \
  --service-name $SERVICE_NAME \
  --task-definition $TASK_DEFINITION \
  --desired-count 1 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[\"$SUBNET_ID\"],securityGroups=[\"$SECURITY_GROUP_ID\"],assignPublicIp=\"ENABLED\"}" \
  --region $AWS_REGION

# Verify ECS Service
aws ecs describe-services --cluster $CLUSTER_NAME --services $SERVICE_NAME --region $AWS_REGION

# Run ECS Task
aws ecs run-task \
  --cluster $CLUSTER_NAME \
  --task-definition $TASK_DEFINITION \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[\"$SUBNET_ID\"],securityGroups=[\"$SECURITY_GROUP_ID\"],assignPublicIp=\"ENABLED\"}" \
  --region $AWS_REGION
