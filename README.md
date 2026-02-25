# 🚀 NTI Final DevOps Project

![Terraform](https://img.shields.io/badge/Terraform-1.7+-623CE4?logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-Cloud-232F3E?logo=amazonaws&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-Orchestration-326CE5?logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Containerization-2496ED?logo=docker&logoColor=white)

> End-to-End DevOps Project implementing Infrastructure as Code, CI/CD automation, containerization, Kubernetes orchestration, and AWS cloud deployment.
> 
---

## 📌 Project Overview

This project demonstrates:

- Infrastructure provisioning using **Terraform**
- Containerization using **Docker**
- CI/CD automation using **GitLab CI**
- Kubernetes deployment with **Amazon EKS**
- Ingress configuration and traffic routing
- Automated validation and teardown scripts

The deployed application is a static web project served inside a containerized Kubernetes environment on AWS.

---

## 🏗️ Architecture Overview

The system follows a complete DevOps lifecycle from code commit to live production deployment:

```
👨‍💻 Developer
        │
        ▼
🦊 GitLab Repository
        │
        ▼
🔁 CI/CD Pipelines
   ├─ Infrastructure Pipeline
   ├─ Platform Pipeline
   ├─ Application CD Pipeline
   └─ Release Pipeline
        │
        ▼
🐳 Docker Image Build & Push
        │
        ▼
⚙️ Terraform (AWS Infrastructure as Code)
        │
        ▼
☁️ AWS Cloud
        │
        ▼
☸️ Amazon EKS Cluster
        │
        ▼
📦 Kubernetes Deployment (Pods & Services)
        │
        ▼
🌐 Ingress / Load Balancer
        │
        ▼
🖥️ Web Application (Live)
```

---

### 🔄 Flow Explanation

1. Developer pushes code to GitLab.
2. CI/CD pipelines are triggered automatically.
3. Docker image is built and pushed to registry.
4. Terraform provisions AWS infrastructure.
5. Amazon EKS hosts the Kubernetes cluster.
6. Kubernetes deploys the application.
7. Ingress exposes the service externally.
8. Users access the live web application.

---

💡 **Architecture Highlights**
- Fully automated Infrastructure as Code
- Multi-pipeline GitLab CI structure
- Containerized deployment workflow
- Cloud-native Kubernetes architecture
- Automated validation & controlled teardown
---

## 🛠️ Tech Stack

### ☁️ Cloud & Infrastructure
- AWS
- Amazon EKS
- VPC & Network Load Balancer(NLB)
- API Gateway
- Terraform (Infrastructure as Code)

### 🐳 Containerization
- Docker

### ☸️ Orchestration
- Kubernetes
- Deployment, Service, and Ingress manifests

### 🔁 CI/CD
- GitLab CI/CD (Modular multi-file pipelines)

### 🌐 Application
- Static Website (HTML, CSS, JS)

---

## 📂 Project Structure

```
.
├── .gitlab-ci.yml
├── Dockerfile
├── ci/
|   ├── .gitlab-infra.yml
│   ├── .gitlab-platform.yml
│   ├── .gitlab-ralese.yml (ci)
│   ├── .gitlab-CD.yml
├── k8s/
│   ├── deployment.yml
│   ├── svc.yml
│   ├── ingresses.yml
│   └── namespace.yml
├── root_modules/
│   ├── main.tf
│   ├── provider.tf
│   ├── backend.tf
│   └── output.tf
├── modules/
│   ├── apigateway
│   ├── EKS
│   ├── network
│   ├── NLB
├── scripts/
│   ├── bootstrap.sh
│   ├── deploy-apps.sh
│   ├── ingress.sh
│   ├── validate.sh
│   └── destroy.sh
└── OurWebSite/
```

---


## 🔁 CI/CD Architecture

The CI/CD system is divided into **4 separate pipeline files**, each responsible for a specific layer of the DevOps lifecycle.

These pipelines are modular and organized inside the `ci/` directory.

---

### 🟢 1️⃣ Infrastructure Pipeline  
**File:** `ci/.gitlab-infra.yml`

Responsible for provisioning and managing AWS infrastructure using Terraform.

**Typical Stages:**
- `fmt`
- `validate`
- `plan`
- `apply`
- `destroy (manual)`

This pipeline creates:
- VPC
- EKS Cluster
- Networking components
- Load Balancer integrations

---

### 🔵 2️⃣ Platform Pipeline  
**File:** `ci/.gitlab-platform.yml`

Responsible for configuring the Kubernetes platform after infrastructure creation.

**Typical Stages:**
- Cluster configuration
- Namespace creation
- Base services setup
- Ingress controller setup

This prepares the Kubernetes environment to host applications.

---

### 🟣 3️⃣ Application CD Pipeline  
**File:** `ci/.gitlab-cd.yml`

Responsible for application container lifecycle and deployment.

**Typical Stages:**
- Updating Kubernetes manifests
- ArgoCD synchronization
- Deploying application to EKS
- Post-deployment validation

---

### 🔴 4️⃣ Release / Environment Pipeline  
**File:** `ci/.gitlab-relese.yml`

Responsible for environment lifecycle and production-level actions.

**Typical Stages:**
- Building Docker image
- Pushing image to registry
- Preparing deployment artifacts
- Infrastructure teardown (manual trigger)

---

## 🐳 Docker

### Build Image Locally

```bash
docker build -t ourwebsite .
```

### Run Locally

```bash
docker run -p 8080:80 ourwebsite
```

Open in browser:

```
http://localhost:8080
```

---
---

## ▶️ How to Run This Project

This project is fully automated using Terraform and GitLab CI/CD.  
You can run it in **three different ways** depending on your environment.

---

### 🔹 Option 1: Deploy Infrastructure (Terraform)

Provision AWS infrastructure (VPC, EKS, networking):

```bash
cd root_modules
terraform init
terraform plan
terraform apply
```

To destroy infrastructure:

```bash
terraform destroy
```

✅ This will:
- Create VPC & networking
- Provision Amazon EKS cluster
- Configure load balancing components

---

### 🔹 Option 2: Deploy Application to Kubernetes (Manual)

After infrastructure is ready:

```bash
kubectl apply -f k8s/namespace.yml
kubectl apply -f k8s/deployment.yml
kubectl apply -f k8s/svc.yml
kubectl apply -f k8s/ingresses.yml
```

Verify deployment:

```bash
kubectl get pods -A
kubectl get svc -A
kubectl get ingress -A
```

---

### 🔹 Option 3: Run Full Automation via GitLab CI/CD (Recommended)

Push code to GitLab and trigger pipelines:

1. Infrastructure Pipeline → provisions AWS resources  
2. Platform Pipeline → prepares Kubernetes cluster
3. Release Pipeline → build & bush image 
4. Application CD Pipeline → Update Manifest Repo & ArgoCD Sync & Deploy to EKS

No manual intervention required except optional `destroy` stage.

---

## 🔐 Required Environment Variables

Before running Terraform or CI/CD, configure:

- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_REGION
- TF_STATE_BUCKET
- TF_STATE_KEY

Optional:
- Docker registry credentials
- Vault secrets (if integrated)

---

## 🧪 Validation

Run validation script:

```bash
bash scripts/validate.sh
```

This verifies:
- Cluster connectivity
- Running pods
- Service exposure
- Ingress routing

---

## 🧹 Cleanup

To destroy all infrastructure:

```bash
bash scripts/destroy.sh
```

Or manually:

```bash
terraform destroy
```

---

## 🎯 DevOps Concepts Demonstrated

- Infrastructure as Code (IaC)
- CI/CD automation
- Container lifecycle management
- Kubernetes orchestration
- Cloud-native deployment
- Load balancing and ingress routing
- Infrastructure teardown automation

---

## 👨‍💻 Author

**Mahmoud Abdelhady**  
DevOps Engineer | Cloud & Automation Enthusiast  

---

## 📄 License

This project is for educational and demonstration purposes.

---

![NTI-FINAL-project](https://github.com/user-attachments/assets/b417e207-f11f-4692-9f4e-fd7a68c15ad8)
