# General AWS Configuration
aws_region = "us-east-1"

# Database Configuration
db_name     = "interstellar"
db_user     = "admin"
db_host     = "/interstellar/db_creds/DB_HOST"  # Retrieved from AWS SSM Parameter Store
db_port     = "5432"
db_password = "/interstellar/db_password"      # Stored securely in AWS SSM

# Networking Configuration
vpc_id              = "vpc-0c58473b204cc096c"
public_subnet_ids   = ["subnet-05f873fad9eb89974", "subnet-04b4390b7d6e34c60"]  # Replace with valid subnets in the same VPC
subnet_cidr_block   = "172.31.128.0/20"  # Choose an unused range
availability_zone   = "us-east-1a"      # Ensure this AZ is correct for your subnets
route_table_id      = "rtb-0a42ffa92d22d4c0a"
gateway_id          = "igw-04940983732fa1b70"
allowed_cidr_blocks = ["192.168.1.0/24"] # Restrict to trusted IPs
vpc_endpoint_service_name = "com.amazonaws.us-east-1.s3"

# ECS Configuration
ecs_cluster_name  = "interstellar-cluster"
security_group_id = "sg-04214c54cbf833e41"  # Updated with a valid security group

# ECS Task Definition Configuration
interstellar_image_version = "1.0.0"
container_image = "597088035840.dkr.ecr.us-east-1.amazonaws.com/interstellar-route-planner:latest"

# S3 Configuration
s3_bucket_name = "the-keyholding-bucket-eu-api"  # Ensure this exists
