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