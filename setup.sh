#!/bin/bash

set -e

### CONFIG ###
DOCKER_USER="somehcene"
PROJECT_DIR="$PWD"
YAML_DIR="$PROJECT_DIR/fichiers-yaml"
BACKEND_DIR="$PROJECT_DIR/backend"
FRONTEND_DIR="$PROJECT_DIR/frontend"
################

echo "🚀 Starting IaC & Autoscaling project setup..."

### STEP 1: Docker Login ###
echo "🔐 Logging in to Docker..."
docker login

### STEP 2: Build & Push Backend ###
echo "📦 Building backend image..."
cd "$BACKEND_DIR"
docker build -t backend-image .
docker tag backend-image "$DOCKER_USER/backend-image"
docker push "$DOCKER_USER/backend-image"

### STEP 3: Build & Push Frontend ###
echo "🌐 Building frontend image..."
cd "$FRONTEND_DIR"
docker build -t frontend-image .
docker tag frontend-image "$DOCKER_USER/frontend-image"
docker push "$DOCKER_USER/frontend-image"

### STEP 4: Start Minikube ###
echo "⚙️ Starting Minikube cluster..."
minikube start --driver=docker --force

### STEP 5: Apply YAMLs ###
echo "📜 Applying Kubernetes manifests..."
cd "$YAML_DIR"
kubectl apply -f .

### STEP 6: Show Service URLs ###
echo ""
echo "🔗 Access your services:"
echo "Backend:     $(minikube service backend --url)"
echo "Frontend:    $(minikube service frontend --url)"
echo "Prometheus:  $(minikube service prometheus --url)"
echo "Grafana:     $(minikube service grafana --url)"
echo ""
echo "✅ All set up! Enjoy your cluster 🎉"
