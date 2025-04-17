# 🚀 Interstellar Route Planner

An AI-powered FastAPI microservice to simulate interplanetary travel planning, detect route anomalies, and visualise system metrics using Prometheus and Grafana. Fully containerised and deployed via AWS Fargate and Terraform with CI/CD using GitHub Actions.

---

## 🌐 Live API Endpoints

| Endpoint | Description |
|---------|-------------|
| [`/`](http://interstellar-alb-1825407271.us-east-1.elb.amazonaws.com) | Health check |
| [`/docs`](http://interstellar-alb-1825407271.us-east-1.elb.amazonaws.com/docs) | Swagger UI |
| [`/gates/G1/to/G9`](http://interstellar-alb-1825407271.us-east-1.elb.amazonaws.com/gates/G1/to/G9) | Sample route path |
| [`/anomaly-detection`](http://interstellar-alb-1825407271.us-east-1.elb.amazonaws.com/anomaly-detection) | POST endpoint for anomaly detection |
| [`/metrics`](http://interstellar-alb-1825407271.us-east-1.elb.amazonaws.com/metrics) | Prometheus metrics exposition |

---

## 🏛️ Infrastructure Overview

- **ECS Fargate** (AWS) for scalable containerised deployment
- **Amazon RDS PostgreSQL** for persistent data storage
- **Application Load Balancer (ALB)** for public access
- **Prometheus** (scrapes `/metrics`) for monitoring
- **Grafana** dashboards to visualise metrics and anomalies
- **GitHub Actions** for CI/CD pipeline
- **Terraform** for reproducible infrastructure as code

---

## 📈 Grafana Dashboard Panels

- ✅ Anomaly Detection Signal
- ⚖️ CPU Usage (%) — from Node Exporter
- 📊 Memory Usage (%) — from Node Exporter
- ⏱️ Request Duration Histograms
- 🔢 API Request Rate and Status Codes
- ♥️ PostgreSQL Health (via pg_up)

---

## 🛠️ Dev Commands

```bash
# Start and rebuild the full local stack
$ docker-compose down -v
$ docker-compose up -d --build

# Build and push Docker image to DockerHub
$ docker build --no-cache -t interstellar-app .
$ docker tag interstellar-app ad4johnson/interstellar-app:latest
$ docker push ad4johnson/interstellar-app:latest

# Run stress test
$ python stress_test.py

# View metrics locally or via ALB
$ curl http://localhost:8000/metrics
$ curl http://interstellar-alb-1825407271.us-east-1.elb.amazonaws.com/metrics
```

---

## 🏐 Ports and Source Engines

| Service                | Port | Source Engine                 |
|------------------------|------|-------------------------------|
| FastAPI API            | 8000 | uvicorn/Starlette             |
| Prometheus             | 9090 | prom/prometheus               |
| Grafana                | 3000 | grafana/grafana               |
| Node Exporter          | 9100 | prom/node-exporter            |
| PostgreSQL Exporter    | 9187 | prometheuscommunity/postgres-exporter |
| RDS PostgreSQL         | 5432 | AWS RDS (PostgreSQL engine)   |

---

## 📦 Terraform Management

```bash
$ terraform init
$ terraform plan -var-file="terraform.tfvars"
$ terraform apply -var-file="terraform.tfvars"
$ terraform destroy -var-file="terraform.tfvars"
$ terraform state list
```

---

## 🔢 Git Best Practices

```bash
$ git init
$ echo ".DS_Store" >> .gitignore
$ git add .
$ git commit -m "🔧 Setup: Clean infra + metrics integration"
$ git push origin main
```

---

## 🚫 Known Issues

- Ensure `.env` is loaded for Docker builds
- Rebuild with `--no-cache` to ensure metrics reinitialise
- Verify Prometheus target discovery for `/metrics` scrape

---

**Maintained by:** adejohnson / `ad4johnson` on DockerHub

