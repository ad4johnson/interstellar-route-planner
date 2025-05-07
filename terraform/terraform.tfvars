# =====================================
# ✅ General AWS Configuration
# =====================================
aws_region = "us-east-1"

# =====================================
# ✅ Database Configuration
# =====================================
db_name     = "interstellar"
db_user     = "interstellardbadmin"
db_password = "T4rraform123" # Stored securely in SSM Parameter Store
db_host     = "interstellar-db.cte24y8cq8cw.us-east-1.rds.amazonaws.com"
db_port     = "5432"

# ECS Autoscaling
ecs_min_capacity = 2
ecs_max_capacity = 10

# =====================================
# ✅ Networking Configuration
# =====================================
vpc_id                    = "vpc-03af2a1307575b473"
vpc_cidr_block            = "10.0.0.0/16"
vpc_endpoint_service_name = "com.amazonaws.us-east-1.s3"

# Subnets (Public)
public_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_azs         = ["us-east-1a", "us-east-1b"]

# Optional (for compatibility with old modules or IGW/RouteTable modules)
route_table_id = "rtb-0d7587ce71905b403"
gateway_id     = "igw-0478495b9ea27b340"

# =====================================
# ✅ ECS Configuration
# =====================================
ecs_cluster_name = "interstellar-cluster"

# =====================================
# ✅ ECS Task Definition Configuration
# =====================================
container_image            = "ad4johnson/interstellar-app:latest"
interstellar_image_version = "1.0.0"
ecs_task_cpu               = 1024
ecs_task_memory            = 2048

# =====================================
# ✅ S3 Configuration
# =====================================
s3_bucket_name   = "the-keyholding-bucket-eu-api"
s3_bucket_region = "us-east-1"

# =====================================
# ✅ DockerHub Credentials
# =====================================
docker_username = "ad4johnson"
docker_password = "T4rraform!"