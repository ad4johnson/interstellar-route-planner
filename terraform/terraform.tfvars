# =====================================
# ✅ General AWS Configuration
# =====================================
aws_region = "us-east-1"

# =====================================
# ✅ Database Configuration
# =====================================
db_name     = "interstellar"
db_user     = "interstellardbadmin"
db_password = "T4rraform123" # Stored in SSM Parameter Store
db_host     = "interstellar-db.cte24y8cq8cw.us-east-1.rds.amazonaws.com"
db_port     = "5432"
ecs_min_capacity           = 2
ecs_max_capacity           = 10
# =====================================
# ✅ Networking Configuration
# =====================================
vpc_id                    = "vpc-0c58473b204cc096c"
public_subnet_ids         = ["subnet-05f873fad9eb89974", "subnet-04b4390b7d6e34c60"]
availability_zone         = "us-east-1a"
subnet_cidr_block         = "172.31.128.0/20"
route_table_id            = "rtb-0a42ffa92d22d4c0a"
gateway_id                = "igw-04940983732fa1b70"
allowed_cidr_blocks       = ["104.239.49.181/32"] # Replace with 0.0.0.0/0 if dynamic
local_ip                  = "104.239.49.181/32"
vpc_endpoint_service_name = "com.amazonaws.us-east-1.s3"

# =====================================
# ✅ ECS Configuration
# =====================================
ecs_cluster_name  = "interstellar-cluster"
security_group_id = "sg-04214c54cbf833e41"

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