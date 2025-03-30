# ===========================
# General Configuration
# ===========================
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  sensitive   = true
}

# ===========================
# ECS Cluster Configuration
# ===========================
variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  sensitive   = true
}

variable "ecs_task_cpu" {
  description = "CPU units for ECS tasks"
  type        = number
  sensitive   = true
  default     = 256
}

variable "ecs_task_memory" {
  description = "Memory allocation for ECS tasks"
  type        = number
  sensitive   = true
  default     = 512
}

# ===========================
# Networking Configuration
# ===========================
variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "The IDs of the public subnets"
  type        = list(string)
}

variable "security_group_id" {
  description = "The ID of the security group"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "The CIDR blocks allowed for access"
  type        = list(string)
  default     = [] # Secure default: no unrestricted access
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
  sensitive   = true
}

variable "availability_zone" {
  description = "The availability zone for the subnet"
  type        = string
  sensitive   = true
}

variable "vpc_endpoint_service_name" {
  description = "The name of the VPC endpoint service"
  type        = string
  sensitive   = true
}

variable "route_table_id" {
  description = "The ID of the route table"
  type        = string
  sensitive   = true
}

variable "gateway_id" {
  description = "The ID of the internet gateway"
  type        = string
  sensitive   = true
}

# ===========================
# ECS Task Definition Configuration
# ===========================
variable "interstellar_image_version" {
  description = "The version of the Interstellar Docker image"
  type        = string
  sensitive   = true
  default     = "1.0.0"
}

variable "container_image" {
  description = "The Docker image for the interstellar container"
  type        = string
  sensitive   = true
}

# ===========================
# Database Configuration
# ===========================
variable "db_name" {
  description = "The name of the database"
  type        = string
  sensitive   = true
  default     = "interstellar"
}

variable "db_user" {
  description = "The username for the database"
  type        = string
  sensitive   = true
  default     = "admin"
}

variable "db_host" {
  description = "The host of the database (retrieved from AWS SSM Parameter Store)"
  type        = string
  sensitive   = true
  default     = "/interstellar/db_creds/DB_HOST"
}

variable "db_port" {
  description = "The port of the database"
  type        = string
  sensitive   = true
  default     = "5432"
}

variable "db_password" {
  description = "The password for the database (stored securely in AWS SSM)"
  type        = string
  sensitive   = true
  default     = "/interstellar/db_password"
}

# ===========================
# S3 Configuration
# ===========================
variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
  sensitive   = true
}