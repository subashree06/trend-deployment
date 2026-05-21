# 🛍️ Trend App – DevOps Deployment

Production deployment of the **Trend** React e-commerce application using a full DevOps pipeline on AWS.

---

## 📁 Repository Structure

```
trend-deployment/
│
├── Dockerfile               ← Build & serve the app on port 3000
├── docker-compose.yml       ← Local testing with one command
├── Jenkinsfile              ← 7-stage CI/CD pipeline
├── prometheus.yml           ← Prometheus scrape config
├── alert.rules.yml          ← Prometheus alerting rules
├── .gitignore
├── .dockerignore
│
├── dist/                    ← Pre-built React app (ready to deploy)
│   ├── index.html
│   └── assets/
│
├── terraform/
│   ├── main.tf              ← VPC, EC2 (Jenkins), EKS cluster
│   └── terraform-commands.md
│
├── kubernetes/
│   ├── deployment.yaml      ← 2-replica app deployment
│   ├── service.yaml         ← AWS LoadBalancer service
│   ├── monitoring.yaml      ← Prometheus + Grafana
│   └── kubectl-commands.md
│
├── jenkins/
│   └── jenkins-setup.md     ← Plugin install + pipeline setup guide
│
└── screenshots/             ← Deployment proof screenshots
```

---

## 🏗️ Architecture

```
  Developer (Windows VS Code)
          │
          │  git push
          ▼
      GitHub Repo
          │
          │  Webhook trigger
          ▼
   Jenkins (EC2 t2.micro)
          │
    ┌─────┴──────────────────────────┐
    │  1. Checkout from GitHub       │
    │  2. docker build               │
    │  3. Test container             │
    │  4. docker push → DockerHub    │
    │  5. kubectl → EKS connect      │
    │  6. kubectl apply → Deploy     │
    │  7. Print LoadBalancer URL     │
    └────────────────────────────────┘
          │
          ▼
    AWS EKS Cluster
    ├── trend-app Pod ×2  ──→  LoadBalancer ──→  Public URL
    └── monitoring/
            ├── Prometheus
            └── Grafana Dashboard
```

---

## 🚀 Deployment Phases

### Phase 1 — Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/trend-deployment.git
cd trend-deployment
```

---

### Phase 2 — Docker (Build & Run Locally)
```bash
# Build image
docker build -t trend-app .

# Run on port 3000
docker run -d -p 3000:3000 --name trend-app trend-app

# OR use docker-compose
docker-compose up
```
✅ Open browser → **http://localhost:3000**

---

### Phase 3 — Push to DockerHub
```bash
docker tag trend-app YOUR_DOCKERHUB_USERNAME/trend-app:latest
docker login
docker push YOUR_DOCKERHUB_USERNAME/trend-app:latest
```

---

### Phase 4 — Terraform (AWS Infrastructure)
```bash
cd terraform
terraform init
terraform apply -var="key_name=trend-key" -auto-approve
```
⏱️ ~15 minutes. Creates: VPC, Subnets, IGW, EC2 (Jenkins), EKS Cluster.

---

### Phase 5 — Jenkins Setup
1. Open `http://<jenkins_ip>:8080`
2. Install plugins: Docker Pipeline, Kubernetes, GitHub Integration
3. Add DockerHub credential (ID: `dockerhub-credentials`)
4. Create Pipeline job → point to `Jenkinsfile`
5. Set up GitHub Webhook → auto-build on every push

> See [jenkins/jenkins-setup.md](jenkins/jenkins-setup.md) for full steps.

---

### Phase 6 — Kubernetes (Verify)
```bash
aws eks update-kubeconfig --region us-east-1 --name trend-app
kubectl get nodes          # 2 nodes Ready
kubectl get pods           # 2 pods Running
kubectl get svc            # Copy EXTERNAL-IP → live app URL
```

---

### Phase 7 — Monitoring (Prometheus + Grafana)
```bash
kubectl apply -f kubernetes/monitoring.yaml
kubectl get svc -n monitoring   # Get Grafana IP
```
Login: `admin / admin123` → Import dashboard ID **3119**

---

## 🔁 CI/CD Pipeline Stages

| # | Stage | What Happens |
|---|-------|-------------|
| 1 | Checkout | Pull latest code from GitHub |
| 2 | Build | `docker build` creates container image |
| 3 | Test | Spin up container, verify it starts |
| 4 | Push | Push versioned image to DockerHub |
| 5 | Configure | Connect kubectl to EKS cluster |
| 6 | Deploy | Rolling update via `kubectl apply` |
| 7 | Verify | Print public LoadBalancer URL |

> **Auto-trigger**: Every `git push` fires a new build via GitHub Webhook.

---

## ⚙️ Before You Start — Replace These Values

In **`Jenkinsfile`** (line 10–11):
```groovy
DOCKERHUB_USERNAME = 'YOUR_DOCKERHUB_USERNAME'
url: 'https://github.com/YOUR_GITHUB_USERNAME/trend-deployment.git'
```

In **`kubernetes/deployment.yaml`** (line 28):
```yaml
image: YOUR_DOCKERHUB_USERNAME/trend-app:latest
```

---

## 💰 AWS Cost Estimate

| Resource | Free Tier | Cost/hr |
|----------|-----------|---------|
| EC2 t2.micro (Jenkins) | ✅ Yes | $0 |
| EKS Cluster | ❌ No | ~$0.10 |
| EKS Nodes t3.small ×2 | ❌ No | ~$0.05 each |
| Classic LoadBalancer | ❌ No | ~$0.025 |

> ⚠️ **Run `terraform destroy` after submission to stop charges!**

---

## 🛑 Teardown

```bash
kubectl delete -f kubernetes/
kubectl delete -f kubernetes/monitoring.yaml
cd terraform && terraform destroy -var="key_name=trend-key" -auto-approve
```

---

## 📸 Screenshots

See [screenshots/](screenshots/) folder for deployment proof.

---

## 🛠️ Tech Stack

`React` · `Docker` · `DockerHub` · `Terraform` · `AWS VPC` · `AWS EC2` · `AWS EKS` · `Jenkins` · `Kubernetes` · `Prometheus` · `Grafana` · `GitHub Webhooks`
