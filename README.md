# 🚀 Interstellar Route Planner (AI-Powered + Cloud-Native)

> A production-ready, AI-enhanced FastAPI microservice powered by AWS ECS, RDS, Prometheus, and Grafana for route planning, anomaly detection, and real-time observability.

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

---

## 📚 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Project Infrastructure Overview](#-project-infrastructure-overview)
- [Architecture Diagram](#-architecture-diagram)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Monitoring](#monitoring-prometheus--grafana)
- [AI Anomaly Detection](#ai-anomaly-detection)
- [Destroy Cloud Infra](#destroy-cloud-infra)
- [License](#license)
- [Contributing](#contributing)
- [Credits](#credits)

---

## 📦 Overview

The Interstellar Route Planner is a scalable, observable, and intelligent API platform designed to plan routes in space with AI-driven anomaly detection.  
Built for the cloud with modern DevOps practices, it ensures robust service delivery, monitoring, and continuous integration.

---

## 🛠️ Features

✅ FastAPI backend serving real-time route planning API  
✅ Integrated Anomaly Detection using trained ML model (.pkl)  
✅ CI/CD with GitHub Actions for automated deployment  
✅ AWS Fargate based microservice deployment  
✅ PostgreSQL via Amazon RDS for durable data storage  
✅ API Gateway + ALB for public routing  
✅ Prometheus + Grafana dashboards for real-time monitoring  
✅ S3 bucket for storage/logging  
✅ Secrets and configs managed securely via AWS SSM Parameter Store

---

## 📊 Project Infrastructure Overview

The Interstellar Route Planner leverages modern cloud and DevOps architecture to ensure scalability, reliability, and observability.

**Core Components**:

- **GitHub Actions** → CI/CD pipeline
- **ALB & API Gateway** → Load balancing and routing
- **ECS Fargate** → Compute (Interstellar API + Anomaly Detection)
- **Amazon RDS** → PostgreSQL backend
- **Prometheus & Grafana** → Monitoring and alerting
- **S3 Bucket** → Storage of logs and backups
- **IAM Roles & SSM Parameter Store** → Security and configuration
- **AI ML Model** → Anomaly Detection (Isolation Forest)

---

## 🚀 Getting Started

### Requirements

- Docker + Docker Compose
- Terraform
- AWS Account (ECS + RDS + S3 + CloudWatch)
- Python 3.9+

---

### Local Development

```bash
docker compose up --build

Local Endpoints:

    API → http://localhost:8000/docs

    Prometheus → http://localhost:9090

    Grafana → http://localhost:3000 (admin/admin)

---

Stress Test (optional)
python stress_test.py

---
Cloud Deployment (Terraform)

Update terraform/terraform.tfvars:

aws_region = "us-east-1"
db_name    = "interstellar"
...
container_image = "ad4johnson/interstellar-app:latest"

---
Deploy:

cd terraform
terraform init
terraform plan
terraform apply

After apply, you will get the ALB public URL:

http://interstellar-alb-XXXX.elb.amazonaws.com/docs
http://interstellar-alb-XXXX.elb.amazonaws.com/metrics

---
📊 Monitoring (Prometheus + Grafana)

Pre-configured dashboards include:

    Anomaly Detection Signal

    API Request Rates and Status

    Resource Usage (CPU / MEM / DB Health)

    Request Duration and Errors

Grafana automatically discovers the Prometheus datasource when running locally.


**🤖 AI Anomaly Detection**

ML Model: Isolation Forest (Pre-trained .pkl model)

Endpoint: /anomaly-detection

curl -X POST http://localhost:8000/anomaly-detection \
    -H "Content-Type: application/json" \
    -d '{"values": [[0.5, 0.1, 0.8, ..., 0.3]]}'

curl -X POST http://localhost:8000/anomaly-detection \
    -H "Content-Type: application/json" \
    -d '{"values": [[0.5, 0.1, 0.8, ..., 0.3]]}'

**Response:**

{
  "anomalies_detected": true,
  "anomaly_indices": [0]
}

---

**Prometheus metrics:**

anomaly_detected 0.0 / 1.0

---
**💣 Destroy Cloud Infra (optional)**

cd terraform
terraform destroy

---
📄 **License**

MIT License.

----

**🤝 Contributing**

Pull Requests and Issues are welcome.

    Fork this repository

    Create a new branch (feature/my-feature)

    Commit and push your changes

    Open a Pull Request

---

**📬 Credits**

Built and maintained by Ade Johnson

    Created as part of an academic research project on AI-powered anomaly detection in cloud-native environments.
