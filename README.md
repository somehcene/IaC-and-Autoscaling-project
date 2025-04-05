# IaC and Autoscaling Project 🚀

This project demonstrates a full-stack application with autoscaling and monitoring using **Kubernetes**, **Docker**, **Prometheus**, and **Grafana**.

---

## 🧱 Technologies Used

- **Docker**: Containerization of backend & frontend
- **Kubernetes (Minikube)**: Cluster management, autoscaling with HPA
- **Redis**: Master-slave setup with replication
- **Prometheus**: Metrics collection
- **Grafana**: Monitoring dashboards
- **Node.js**: Backend logic
- **React.js**: Frontend interface

---

## 📁 Project Structure

```plaintext

IaC-and-Autoscaling-project/
├── backend/                       # Node.js application with Dockerfile
│   ├── Dockerfile
│   ├── main.js
│   ├── package.json
│   └── ...
├── frontend/                      # React application with Dockerfile
│   ├── Dockerfile
│   ├── src/
│   └── ...
├── fichiers-yaml/                 # Kubernetes manifests
│   ├── backend-deployment.yaml
│   ├── backend-service.yaml
│   ├── backend-auto-scaling.yaml
│   ├── frontend-deployment.yaml
│   ├── frontend-service.yaml
│   ├── redis-maitre-deployment.yaml
│   ├── redis-maitre-service.yaml
│   ├── redis-esclave-deployment.yaml
│   ├── redis-esclave-service.yaml
│   ├── redis-esclave-auto-scaling.yaml
│   ├── prometheus-cfg.yaml
│   ├── prometheus-deployment.yaml
│   ├── prometheus-service.yaml
│   ├── grafana-deployment.yaml
│   └── grafana-service.yaml
├── README.md

```

---

## ▶️ How to Run

### 1. Install Docker & Kubernetes (Minikube)
Follow the official installation guides for [Docker](https://docs.docker.com/get-docker/) and [Minikube](https://minikube.sigs.k8s.io/docs/start/).

### 2. Start Minikube

```bash
minikube start --force
```

### 3. Apply Kubernetes Manifests

```bash
kubectl apply -f fichiers-yaml/
```

### 4. Access Services

```bash
minikube service backend --url
minikube service frontend --url
minikube service prometheus --url
minikube service grafana --url
```

---

## 📊 Monitoring

- Visit **Grafana** and configure Prometheus as a data source.
- Dashboards can be imported for Redis/Node.js metrics visualization.

---

## 🧠 Author

> Ahcene Loubar – `@somehcene`

---
