# 🚀 Interstellar Route Planner — AI-Powered API

An AI-powered FastAPI microservice to simulate interplanetary travel planning, detect route anomalies, and visualise system metrics using Prometheus and Grafana. Fully containerised and deployed via AWS Fargate and Terraform with CI/CD using GitHub Actions.

---

## 📁 Features

- ⚙️ FastAPI application with OpenAPI documentation
- 🧠 Anomaly detection using trained Isolation Forest model (`anomaly_detector.pkl`)
- 🗔️ PostgreSQL database on Amazon RDS
- 🐳 Dockerized and deployed to ECS Fargate
- 📈 Real-time monitoring via Prometheus + Grafana
- 🔒 IAM roles, SSM for secrets, and Terraform IaC
- ⚡ CI/CD via GitHub Actions and DockerHub

---

## 📦 Tech Stack Overview

| Layer             | Technology                           |
|-------------------|--------------------------------------|
| Backend API       | FastAPI (Python)                     |
| AI Model          | Scikit-learn IsolationForest         |
| DB                | Amazon RDS (PostgreSQL)              |
| Infra Deployment  | Terraform + AWS Fargate              |
| Monitoring        | Prometheus, Grafana                  |
| Exporters         | Node Exporter, Postgres Exporter     |
| Container Image   | DockerHub: `ad4johnson/interstellar-app:latest` |

---

## 📡 Live Endpoints

| URL | Description |
|-----|-------------|
| `http://<ALB-DNS>/docs` | Swagger UI API Docs |
| `http://<ALB-DNS>/metrics` | Prometheus metrics endpoint |
| `http://<Grafana-DNS>` (optional) | Grafana dashboard |

---

## 🫠 Anomaly Detection

- `/analyze` route uses a trained Isolation Forest model.
- Returns JSON:
```json
{ "anomalies_detected": true/false, "anomaly_indices": [0, 1, ...] }
```
- Custom Prometheus metric `anomaly_detection_signal` is exposed.

---

## 📊 Monitoring Stack

Prometheus scrapes metrics from:
- FastAPI app (`/metrics`)
- Node Exporter (`:9100`)
- Postgres Exporter (`:9187`)

Grafana panels include:
- Anomaly Detection Signal
- API Request Rate and Latency
- Request Status Codes (2xx, 4xx, etc.)
- CPU and Memory Usage
- PostgreSQL Database Health (`pg_up`)

---

## 🔍 Exposed Prometheus Metrics

| Metric Name | Description |
|-------------|-------------|
| `http_requests_total` | Total API calls |
| `http_response_status` | HTTP status code breakdown |
| `http_request_duration_seconds` | API request latencies |
| `anomaly_detection_signal` | AI anomaly signal (0/1) |
| `pg_up` | PostgreSQL DB health |
| `node_cpu_seconds_total` | Node CPU usage |
| `node_memory_MemAvailable_bytes` | Node memory availability |

---

## 🛠️ Local Development Steps

1. **Clone the repository:**
```bash
git clone https://github.com/ad4johnson/interstellar-route-planner.git
cd interstellar-route-planner
```

2. **Set up virtual environment and install dependencies:**
```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

3. **Copy and configure `.env`:**
```bash
cp .env.example .env
# Edit .env for DB credentials and API configs
```

4. **Run the FastAPI server locally:**
```bash
uvicorn app.main:app --reload
```

5. **Optional: test DB connectivity:**
```bash
python database_checker.py
```

---

## 🛠️ Dev Commands

```bash
# Start and rebuild the full local stack
docker-compose down -v
docker-compose up -d --build

# Build and push Docker image to DockerHub
docker build --no-cache -t interstellar-app .
docker tag interstellar-app ad4johnson/interstellar-app:latest
docker push ad4johnson/interstellar-app:latest

# Run stress test
python stress_test.py

# View Prometheus metrics
curl http://localhost:8000/metrics
curl http://interstellar-alb-1176058554.us-east-1.elb.amazonaws.com/metrics
```

---

## 🏐 Ports and Source Engines

| Service                | Port | Source Engine                                  |
|------------------------|------|------------------------------------------------|
| FastAPI API             | 8000 | uvicorn/Starlette                              |
| Prometheus              | 9090 | prom/prometheus                                |
| Grafana                 | 3000 | grafana/grafana                                |
| Node Exporter           | 9100 | prom/node-exporter                             |
| PostgreSQL Exporter     | 9187 | prometheuscommunity/postgres-exporter          |
| RDS PostgreSQL          | 5432 | AWS RDS (PostgreSQL engine)                    |

---

## ☁️ Infrastructure Deployment Steps (Terraform)

### Prerequisites
- AWS CLI configured with proper IAM permissions
- Terraform installed and authenticated
- DockerHub credentials (for pushing container images)

### Step-by-Step Deployment

```bash
# Initialise Terraform
terraform init

# Preview infrastructure plan
terraform plan -var-file="terraform.tfvars"

# Apply the infrastructure
terraform apply -var-file="terraform.tfvars"
```

**Verify deployment:**
```bash
echo "ALB DNS: $(terraform output -raw load_balancer_dns)"
curl http://<alb-dns>/docs
```

---

## 🛯️ Common Issues & Remedies

| Issue                  | Cause                              | Fix                                           |
|------------------------|------------------------------------|-----------------------------------------------|
| RDS connection timeout | ECS tasks not allowed in RDS SG    | Add ECS SG to RDS inbound rules               |
| Metrics not showing    | Prometheus config/scraping issue   | Restart Prometheus and verify targets         |
| 502 Bad Gateway (ALB)  | ECS task unhealthy or crashlooping | Check ECS task logs, DB credentials           |
| Anomaly signal missing | Metric not being set               | Ensure `anomaly_signal.set(...)` is called     |
| Metrics empty          | Prometheus middleware missing     | Add `prometheus_fastapi_instrumentator`       |

---

## 📈 Visual Dashboard Example

- Visit: `http://<grafana-url>`
- Import dashboard JSON or use existing panels
- Sample screenshots stored in `/Figures/Monitoring/`

---

## 🗪️ CI/CD Notes

- GitHub Actions triggers build on each `push`
- Docker image is built and pushed to DockerHub
- ECS service can auto-update from DockerHub image if configured

---

## 📬 Contact / Contributions

For questions, issues or contributions, reach out to:

[@ad4johnson on GitHub](https://github.com/ad4johnson)

---

© 2025 — Interstellar Route Planner  
All Rights Reserved.
