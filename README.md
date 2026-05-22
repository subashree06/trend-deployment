<<<<<<< HEAD
# 🚀 Trend Deployment — DevOps Project

## 📌 Project Overview
This repository contains the DevOps pipeline for the Trend application including Infrastructure Provisioning, Containerization, and Kubernetes Deployment.

---

## ✅ Steps Completed
- Infrastructure Provisioning using Terraform
- Containerization using Docker
- Kubernetes Deployment on AWS EKS

---

## 🚀 Deployment Phases

### Phase 1 — Clone Repository

```bash
git clone https://github.com/Vennilavanguvi/Trend.git
cd Trend
```

#### Application Repository Screenshots
![App Repo 1](./screenshots/Screenshot%20(528).png)
![App Repo 2](./screenshots/Screenshot%20(529).png)

---

### Phase 2 — Docker (Build & Run Locally)

#### 🎯 Objective
Dockerize the React application for consistent deployment.

#### 🛠 Steps
- Create a Dockerfile
- Build Docker image
- Run container using Docker

#### 🔧 Commands

```bash
# Build image
docker build -t trend-app .

# Run on port 3000
docker run -d -p 3000:3000 --name trend-app trend-app

# OR use docker-compose
docker-compose up
```

✅ Open browser → http://localhost:3000

#### Docker Screenshots
![Docker 1](./screenshots/Screenshot%20(533).png)
![Docker 2](./screenshots/Screenshot%20(534).png)
![Docker 3](./screenshots/Screenshot%20(535).png)

---

### Phase 3 — Terraform Infrastructure (AWS)

#### 🎯 Objective
Provision AWS infrastructure using Terraform.

#### 🏗 Resources Created
- VPC
- Subnets
- Security Groups
- IAM Roles
- EC2 Instance (Jenkins Server)
- AWS EKS Cluster

#### 🔧 Commands

```bash
terraform init
terraform plan
terraform apply
```

#### Terraform Screenshots
![Terraform Init](./screenshots/terraform.png)
![Terraform Plan](./screenshots/terraform%20(2).png)
![Terraform Apply 3](./screenshots/terraform(3).png)
![Terraform Apply 4](./screenshots/terraform(4).png)
![Terraform Apply 5](./screenshots/terraform(5).png)
![Terraform Apply 6](./screenshots/terraform(6).png)

---

### Phase 4 — DockerHub (Push Image)

#### 🎯 Objective
Create DockerHub repository and push Docker image.

#### 🛠 Steps
- Create DockerHub repository
- Push Docker image

#### 🔧 Commands

```bash
docker login
docker tag trendify-app:latest subashree06/trendify-app:latest
docker push subashree06/trendify-app:latest
```

#### DockerHub Screenshots
![DockerHub Image](./screenshots/03-dockerhub-image.png.png)
![DockerHub Push](./screenshots/03-dockerhub-push.png.png)
![DockerHub](./screenshots/dockerhub.png)

---

### Phase 5 — Kubernetes (AWS EKS)

#### 📌 Objective
Deploy application in Kubernetes cluster on AWS EKS.

#### 🧱 Steps

**1. Setup EKS Cluster**

```bash
eksctl create cluster --name trend-cluster --region us-east-1 --version 1.31 --nodegroup-name linux-nodes --node-type t3.micro --nodes 1 --managed
```

![EKS Cluster Setup](./screenshots/Screenshot%20(566).png)

---

**2. Create Deployment YAML**

**3. Create Service YAML (LoadBalancer)**

#### 📄 Files
- `deployment.yaml`
- `service.yaml`

---

**4. Deploy**

```bash
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

**5. Verify**

```bash
kubectl get pods
kubectl get svc
```

#### Kubernetes Screenshots
![Kubernetes 1](./screenshots/Screenshot%20(567).png)
![Kubernetes 2](./screenshots/Screenshot%20(568).png)

---

**6. Access Application**

🌐 http://a823951091d3146818a89f5f0d989b76-72434611.us-east-1.elb.amazonaws.com/

#### Application Screenshots
![App 1](./screenshots/Screenshot%20(569).png)
![App 2](./screenshots/Screenshot%20(570).png)
![App 3](./screenshots/Screenshot%20(577).png)
![App 4](./screenshots/Screenshot%20(580).png)

---
---

### Phase 6 — Version Control (GitHub)

#### 🎯 Objective
Push complete project code to GitHub repository.

#### 🛠 Steps
- Push code to GitHub repository
- Add .gitignore
- Add .dockerignore

#### 🚀 Commands

```bash
git init
git remote remove origin
git remote add origin https://github.com/subashree06/trend-deployment.git
git remote -v
git add .
git commit -m "Initial commit: Trend app full DevOps project"
git branch -M main
git push -u origin main --force
```

#### Version Control Screenshots
![GitHub 1](./screenshots/Screenshot%20(582).png)
![GitHub 2](./screenshots/Screenshot%20(583).png)

---
## 🔁 Phase 6 – Jenkins CI/CD Pipeline

### 🚀 Pipeline Flow

GitHub → Jenkins → Build → Docker Image → DockerHub → Kubernetes (EKS)

### 📌 Features
- Auto build on every commit
- Docker image creation
- Push to DockerHub
- Deploy to AWS EKS

### ⚙️ Jenkins Pipeline Screenshots

![Jenkins 1](screenshots/screenshot(584).png)
![Jenkins 2](screenshots/screenshot(585).png)
![Jenkins 3](screenshots/screenshot(586).png)
![Jenkins 4](screenshots/screenshot(587).png)
![Jenkins 5](screenshots/screenshot(588).png)
![Jenkins 6](screenshots/screenshot(589).png)
![Jenkins 7](screenshots/screenshot(590).png)
![Jenkins 8](screenshots/screenshot(591).png)
![Jenkins 9](screenshots/screenshot(592).png)
![Jenkins 10](screenshots/screenshot(593).png)
![Jenkins 11](screenshots/screenshot(594).png)
![Jenkins 12](screenshots/screenshot(595).png)

## 📊 Phase 7 – Monitoring (Prometheus + Grafana)

### 📌 Tools Used
- Prometheus
- Grafana

### 📈 Metrics Monitored
- CPU Usage
- Memory Usage
- Pod Health
- Node Status

### 📸 Monitoring Screenshots

## 📊 Phase 7 – Monitoring (Prometheus + Grafana)

![Monitoring 1](screenshots/Screenshot%20%28608%29.png)
![Monitoring 2](screenshots/Screenshot%20%28609%29.png)
![Monitoring 3](screenshots/Screenshot%20%28610%29.png)
![Monitoring 4](screenshots/Screenshot%20%28611%29.png)
![Monitoring 5](screenshots/Screenshot%20%28612%29.png)
![Monitoring 6](screenshots/Screenshot%20%28614%29.png)
![Monitoring 7](screenshots/Screenshot%20%28615%29.png)
![Monitoring 8](screenshots/Screenshot%20%28616%29.png)
![Monitoring 9](screenshots/Screenshot%20%28617%29.png)
![Monitoring 10](screenshots/Screenshot%20%28618%29.png)
![Monitoring 11](screenshots/Screenshot%20%28619%29.png)
![Monitoring 12](screenshots/Screenshot%20%28620%29.png)
![Monitoring 13](screenshots/Screenshot%20%28621%29.png)

## 🛠️ Tech Stack

| Technology | Purpose |
|------------|---------|
| React + Vite | Frontend application |
| Docker | Containerization |
| DockerHub | Container registry |
| Terraform | Infrastructure as Code |
| AWS VPC | Networking |
| AWS EC2 | Jenkins server |
| AWS EKS | Kubernetes cluster |
| Jenkins | CI/CD automation |
| Kubernetes | Container orchestration |
| Prometheus | Metrics collection |
| Grafana | Monitoring dashboards |
| GitHub | Version control + Webhooks |












