#!/bin/bash

ACR_NAME="eduaz400batchdemo$(date +%s)" 
IMAGE_NAME="hello-world-aks"
IMAGE_TAG="latest"

echo "Deploying Hello World application to AKS..."

echo "Building Docker image..."

docker buildx build --platform linux/amd64 -t $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG $ACR_NAME --push .

echo "Tagging image for ACR..."
docker tag $IMAGE_NAME:$IMAGE_TAG $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

echo "Logging into ACR..."
az acr login --name $ACR_NAME

echo "Pushing image to ACR..."
docker push $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG

echo "Updating deployment manifest..."
sed -i.bak "s|image: hello-world-aks:latest|image: $ACR_NAME.azurecr.io/$IMAGE_NAME:$IMAGE_TAG|g" k8s-deployment.yaml


echo "Getting AKS Creds"
az aks get-credentials --resource-group edu-az400-batch --name aks-hello-world-v2

echo "Deploying to Kubernetes..."
kubectl apply -f k8s-deployment.yaml
kubectl apply -f k8s-service.yaml

echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/hello-world-app

echo "Getting service information..."
kubectl get service hello-world-service

echo "Deployment completed!"
echo "You can check the status with: kubectl get pods"
echo "To get the external IP: kubectl get service hello-world-service"