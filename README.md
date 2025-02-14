# 🚀 Interstellar Route Planner

## 📌 Project Overview

The **Interstellar Route Planner** is a backend system designed to calculate and optimise interstellar travel routes. The system is containerised using **Docker**, deployed on **AWS ECS**, and follows best DevOps practices with **Terraform** for infrastructure automation.

## ✨ Features

- 📍 **Dynamic Route Optimisation** – Calculates the most efficient travel paths between space stations.
- ☁️ **Cloud-Native Deployment** – Runs on AWS using ECS, RDS, and Load Balancers.
- 🛠 **Infrastructure as Code (IaC)** – Uses Terraform for managing AWS resources.
- 🚀 **CI/CD Integration** – Automated deployments via GitHub Actions.
- 📡 **Monitoring & Logging** – Integrated with AWS CloudWatch and Grafana.

## 🏗 Tech Stack

- **Backend:** Python (Flask/FastAPI)
- **Database:** PostgreSQL (AWS RDS)
- **Containerisation:** Docker
- **Orchestration:** AWS ECS (Elastic Container Service)
- **Infrastructure:** Terraform
- **CI/CD:** GitHub Actions
- **Monitoring:** AWS CloudWatch & Grafana

## 📊 Infrastructure Architecture

The architecture consists of:

- **AWS VPC** – Isolated network environment.
- **AWS ECS** – Manages containers for the backend service.
- **AWS RDS** – PostgreSQL database for persistent storage.
- **AWS ALB** – Load balancer for handling requests.
- **CloudWatch & Grafana** – Logs, metrics, and system monitoring.

📌 **View the Architecture Diagram:**
🔗 [Click here to view the full-size diagram](https://raw.githubusercontent.com/your-username/interstellar-route-planner/main/docs/interstellar_route_planner_architecture.png) https://github.com/ad4johnson/interstellar-route-planner/blob/main/docs/interstellar_route_planner_architecture.png

## 📡 Monitoring & Visualisation

We use **Grafana** integrated with **AWS CloudWatch** to monitor system performance in real time.

### **1️⃣ ECS Monitoring Dashboard**

- **Metrics:** CPU Utilisation, Memory Usage, Task Count
- **Query:**
  ```json
  {
    "logGroupName": "/aws/ecs/interstellar-cluster"
  }
  ```
- **Visualisation:** Time Series Graph

### **2️⃣ RDS Monitoring Dashboard**

- **Metrics:** Database Connections, CPU Usage, Read/Write Latency
- **Query:**
  ```json
  {
    "logGroupName": "/aws/rds/instance/database-1/postgresql"
  }
  ```
- **Visualisation:** Bar Chart

### **3️⃣ ALB (Load Balancer) Dashboard**

- **Metrics:** Request Count, Response Time, 4xx/5xx Errors
- **Query:**
  ```json
  {
    "logGroupName": "/aws/elb/interstellar-alb"
  }
  ```
- **Visualisation:** Gauge Chart

## 🔧 Setup Instructions

### 1️⃣ **Clone the Repository**

```sh
git clone https://github.com/ad4johnson/interstellar-route-planner.git
cd interstellar-route-planner
```

### 2️⃣ **Set Up Environment Variables**

Create a `.env` file and add:

```
DB_NAME=interstellar_db
DB_USER=admin
DB_PASSWORD=securepassword
DB_HOST=database-1.cte24y8cq8cw.us-east-1.rds.amazonaws.com
DB_PORT=5432
```

### 3️⃣ **Run Locally with Docker**

```sh
docker-compose up --build
```

### 4️⃣ **Deploy to AWS Using Terraform**

```sh
cd infra
terraform init
terraform apply -auto-approve
```

## 🚀 CI/CD Pipeline

This project uses **GitHub Actions** for automated deployments:

- **Terraform Validation & Deployment**
- **Docker Image Build & Push to AWS ECR**
- **ECS Service Update & Rollout**

## 📡 API Usage

- **Base URL:** `https://interstellar-api.example.com`
- **Endpoints:**
  - `GET /routes` – Fetch available interstellar routes.
  - `POST /calculate` – Optimise a travel path.

## 🤝 Contributing

1. Fork the repo
2. Create a feature branch (`git checkout -b feature-name`)
3. Commit your changes (`git commit -m 'Added new feature'`)
4. Push to GitHub (`git push origin feature-name`)
5. Open a Pull Request

## 📬 Contact

👤 **Ade Johnson**
📧 Email: ad4johnson@gmail.com
🔗 [LinkedIn](https://www.linkedin.com/in/ad4johnson)
