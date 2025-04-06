#!/bin/bash

# === 1. Mise à jour et dépendances ===
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# === 2. Suppression d’anciens Docker éventuels ===
for pkg in docker.io docker-doc docker-compose-v2 podman-docker containerd runc; do
  sudo apt-get remove -y $pkg
done

# === 3. Installation de Docker ===
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# === 4. Test Docker ===
sudo docker run hello-world

# === 5. Installation de kubectl ===
curl -LO "https://dl.k8s.io/release/$(curl -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# === 6. Installation de minikube ===
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
mv minikube-linux-amd64 minikube
chmod +x minikube
sudo install minikube /usr/local/bin/

# === 7. Lancement de Minikube ===
sudo minikube start --force

# === 8. Déploiement Kubernetes ===
cd ~/Documents/CRV-projet/fichiers-yaml

kubectl apply -f redis-maitre-deployment.yaml
kubectl apply -f redis-maitre-service.yaml
kubectl apply -f redis-esclave-deployment.yaml
kubectl apply -f redis-esclave-service.yaml
kubectl apply -f redis-esclave-auto-scaling.yaml

# Metrics server pour le HPA
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
kubectl patch deployment metrics-server -n kube-system \
  --type='json' \
  -p='[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'

# === 9. Docker Build & Push backend ===
cd ../backend
docker build -t backend-image .
docker tag backend-image hcene/backend-image
docker push hcene/backend-image

# === 10. Déploiement backend ===
cd ../fichiers-yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f backend-service.yaml
kubectl apply -f backend-auto-scaling.yaml

# === 11. Docker Build & Push frontend ===
cd ../frontend
docker build -t frontend-image .
docker tag frontend-image hcene/frontend-image
docker push hcene/frontend-image

# === 12. Déploiement frontend ===
cd ../fichiers-yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f frontend-service.yaml

# === 13. Déploiement monitoring ===
kubectl apply -f prometheus-cfg.yaml
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-service.yaml
kubectl apply -f grafana-deployment.yaml
kubectl apply -f grafana-service.yaml

# === 14. Affichage des URLs ===
echo "🔗 Accès backend : $(minikube service backend --url)"
echo "🔗 Accès frontend : $(minikube service frontend --url)"
echo "🔗 Accès Prometheus : $(minikube service prometheus --url)"
echo "🔗 Accès Grafana : $(minikube service grafana --url)"
