#!/bin/bash

# ============================
# ✅ Config: Replace with your ALB DNS
# ============================
ALB_DNS="interstellar-alb-1155191774.us-east-1.elb.amazonaws.com"

# RDS PostgreSQL credentials
DB_HOST="interstellar-db.cte24y8cq8cw.us-east-1.rds.amazonaws.com"
DB_USER="interstellardbadmin"
DB_NAME="interstellar"
DB_PASSWORD="T4rraform123"

echo "📡 Starting metric triggers..."

# ============================
# ✅ 1. Trigger anomaly detection endpoint multiple times
# ============================
echo "🚀 Triggering Anomaly Detection endpoint..."
for i in {1..5}; do
  curl -s -X POST http://$ALB_DNS/anomaly-detection \
    -H "Content-Type: application/json" \
    -d '{"values": [[0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.1, 1.2, 1.3, 1.4, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4, 2.5, 2.6, 2.7, 2.8, 2.9, 3.0, 3.1, 3.2, 3.3, 3.4, 3.5, 3.6, 3.7, 3.8]]}' \
    > /dev/null
  sleep 1
done

# ============================
# ✅ 2. Trigger Route Planner API
# ============================
echo "🌐 Calling route planner API..."
for i in {1..5}; do
  curl -s http://$ALB_DNS/gates/SOL/to/VEG > /dev/null
  sleep 1
done

# ============================
# ✅ 3. Query the RDS PostgreSQL database directly
# ============================
echo "🧠 Executing queries on RDS PostgreSQL..."
for i in {1..5}; do
  PGPASSWORD=$DB_PASSWORD psql -h $DB_HOST -U $DB_USER -d $DB_NAME -c "SELECT COUNT(*) FROM gate;" > /dev/null
  sleep 1
done

echo "✅ All triggers sent. Wait ~10s and refresh Grafana to capture activity."