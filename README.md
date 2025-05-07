# Interstellar Route Planner (AI-Powered + Cloud-Native)

![Grafana Dashboard](./images/monitoring_dashboard.png)

> A production-ready, AI-enhanced FastAPI microservice powered by AWS ECS, RDS, Prometheus, and Grafana for route planning, anomaly detection, and real-time observability.

## Overview

Interstellar Route Planner is a cloud-native service designed to plan optimal space routes while leveraging AI anomaly detection to identify irregular inputs. This project was built for research and production-grade deployments with observability and resilience in mind.

**Core Features:**

* FastAPI backend for route and anomaly APIs
* Machine Learning Anomaly Detection (IsolationForest model)
* Prometheus metrics exposure (`/metrics`)
* Grafana dashboards (preconfigured for monitoring)
* AWS ECS (Fargate) deployment + RDS PostgreSQL
* Local Docker Compose stack for testing
* Stress testing script included

## Architecture

```
User -> API Gateway / ALB -> ECS (Fargate + Interstellar API)
                                     |
                                     v
                              RDS PostgreSQL (AWS)
                                     |
                                     v
  Prometheus -> Grafana (Anomaly, Request, Resource Metrics)
```

* ECS Fargate: Runs the Dockerized Interstellar app
* RDS PostgreSQL: Stores route data and logs
* Prometheus: Scrapes `/metrics` endpoint for monitoring
* Grafana: Dashboards for anomaly signals, API performance, DB health, CPU/MEM usage

## Project structure

```
├── app/
│   ├── anomaly_detection/
│   ├── database.py
│   ├── main.py
├── docker-compose.yml
├── terraform/
├── stress_test.py
├── models/
│   └── anomaly_detector.pkl
├── monitoring/
│   └── prometheus.yml
└── README.md
```

## Getting Started

### Requirements

* Docker + Docker Compose
* Terraform
* AWS Account (for ECS + RDS deployment)
* Python 3.9+

### Local Development

```bash
docker compose up --build
```

**Available at:**

* API -> [http://localhost:8000/docs](http://localhost:8000/docs)
* Prometheus -> [http://localhost:9090](http://localhost:9090)
* Grafana -> [http://localhost:3000](http://localhost:3000) (admin/admin)

### Stress Test (optional)

```bash
python stress_test.py
```

### Cloud Deployment (Terraform)

Update `terraform/terraform.tfvars` with your values:

```hcl
aws_region = "us-east-1"
db_name    = "interstellar"
...
container_image = "ad4johnson/interstellar-app:latest"
```

Then:

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

After apply, you will get the ALB public URL:

```
http://interstellar-alb-XXXX.elb.amazonaws.com
```

#### Access API

```
http://interstellar-alb-XXXX.elb.amazonaws.com/docs
http://interstellar-alb-XXXX.elb.amazonaws.com/metrics
```

## Monitoring (Prometheus + Grafana)

Pre-configured dashboards provide:

* Anomaly Detection Signal (from /metrics)
* API Request Rates and Status
* Resource Usage (CPU / MEM / DB Health)
* Request Duration

Grafana will automatically discover Prometheus data sources when using docker compose.

## AI Anomaly Detection

* Isolation Forest Model (trained on simulated dataset)
* `/anomaly-detection` POST endpoint
* `anomaly_detected` metric exposed for Prometheus

```bash
curl -X POST http://localhost:8000/anomaly-detection \
    -H "Content-Type: application/json" \
    -d '{"values": [[0.5, 0.1, 0.8, ..., 0.3]]}'
```

## Destroy Cloud Infra

```bash
cd terraform
terraform destroy
```

## License

MIT License.

## Contributing

Pull Requests and Issues are welcome.

## Credits

This project was built as part of an academic research project on AI-powered anomaly detection in cloud-native environments.
