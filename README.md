# IaC and Autoscaling Project with Docker, Kubernetes, Prometheus & Grafana

This project demonstrates a full DevOps pipeline using Docker and Kubernetes for deploying a Node.js/React microservice architecture with autoscaling, monitoring, and observability features.

---

## 🛠 Technologies Used

- **Docker**: Containerization of backend & frontend
- **Kubernetes (Minikube)**: Cluster management, autoscaling with HPA
- **Redis**: Master-slave setup with replication
- **Prometheus**: Metrics collection
- **Grafana**: Monitoring dashboards
- **Node.js**: Backend logic
- **React.js**: Frontend interface

---

## 📁 Project Structure
IaC-and-Autoscaling-project/
├── backend/                  # Node.js application with Dockerfile
├── frontend/                 # React application with Dockerfile
├── fichiers-yaml/           # Kubernetes manifests
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
│   ├── grafana-service.yaml
├── README.md


---

## ⚙️ How to Run

### 🐳 1. Install Docker & Kubernetes (Minikube)

```bash
# Already done by you! ✔️

🔧 2. Build Docker Images

cd backend
docker build -t backend-image .
docker tag backend-image somehcene/backend-image
docker push somehcene/backend-image

cd ../frontend
docker build -t frontend-image .
docker tag frontend-image somehcene/frontend-image
docker push somehcene/frontend-image

📦 3. Deploy on Minikube

minikube start --force
kubectl apply -f fichiers-yaml/

You can also apply resources individually for better debugging:

kubectl apply -f redis-maitre-deployment.yaml
kubectl apply -f redis-esclave-deployment.yaml
kubectl apply -f backend-deployment.yaml
kubectl apply -f frontend-deployment.yaml
kubectl apply -f prometheus-cfg.yaml
kubectl apply -f prometheus-deployment.yaml
kubectl apply -f grafana-deployment.yaml

🔄 Horizontal Pod Autoscaling

kubectl get hpa

You should see backend-auto-scaling and redis-esclave-auto-scaling running and scaling pods based on CPU load.
🔍 Access Services

minikube service backend --url     # Node.js API
minikube service frontend --url    # React app
minikube service prometheus --url  # Prometheus dashboard
minikube service grafana --url     # Grafana dashboard

Default Grafana login:

    User: admin

    Pass: admin (or your setup)

🧪 Test Redis Replication

Set value from master:

kubectl exec -it deploy/redis-maitre -- redis-cli
> set test "Ahcene LOUBAR"

Read from any slave:

kubectl exec -it deploy/redis-esclave -- sh
# while true; do redis-cli get test; done

You should see consistent replication: "Ahcene LOUBAR"
💡 Troubleshooting Tips

    Make sure to use SSH authentication for GitHub.

    Don't run Minikube as root with Docker driver (unless --force is specified).

    Avoid using cd documents (case-sensitive: Documents).

    To re-deploy a service: kubectl delete -f file.yaml && kubectl apply -f file.yaml

    For network issues, always validate with minikube service <name> --url

📦 Deployment Notes

    Both backend & frontend use multistage Docker builds for optimized image size.

    Prometheus is configured with custom prometheus-cfg.yaml.

    Autoscaling targets are set to 50% CPU usage.

📍 Author

👤 Ahcene Loubar
📧 hceneloubar@gmail.com
