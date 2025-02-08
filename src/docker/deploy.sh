#!/bin/bash

set -e  # Exit on error

echo "Building Docker Image..."
docker build -t interstellar-api:latest .

echo "Tagging Image..."
docker tag interstellar-api:latest 597088035840.dkr.ecr.us-east-1.amazonaws.com/interstellar-api:latest

echo "Logging into AWS ECR..."
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 597088035840.dkr.ecr.us-east-1.amazonaws.com

echo "Pushing Image to ECR..."
docker push 597088035840.dkr.ecr.us-east-1.amazonaws.com/interstellar-api:latest

echo "Updating ECS Service..."
aws ecs update-service --cluster interstellar-cluster --service interstellar-service --force-new-deployment

echo "Deployment complete!"