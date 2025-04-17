# ===========================
# General Configuration
# ===========================
variable "aws_region" {
  description = "The AWS region where resources will be deployed"
  type        = string
}

# ===========================
# ECS Cluster Configuration
# ===========================
variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "ecs_task_cpu" {
  description = "CPU units for ECS tasks"
  type        = number
  default     = 1024
}

variable "ecs_task_memory" {
  description = "Memory allocation for ECS tasks"
  type        = number
  default     = 2048
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
  default     = []
}

variable "subnet_cidr_block" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "availability_zone" {
  description = "The availability zone for the subnet"
  type        = string
}

variable "vpc_endpoint_service_name" {
  description = "The name of the VPC endpoint service"
  type        = string
}

variable "route_table_id" {
  description = "The ID of the route table"
  type        = string
}

variable "gateway_id" {
  description = "The ID of the internet gateway"
  type        = string
}

# ===========================
# ECS Task Definition Configuration
# ===========================
variable "interstellar_image_version" {
  description = "The version of the Interstellar Docker image"
  type        = string
  default     = "1.0.0"
}

variable "container_image" {
  description = "The container image for the Interstellar application"
  type        = string
}

# Autoscaling Configuration
# ==============================
variable "ecs_min_capacity" {
  type        = number
  default     = 1
  description = "Minimum number of ECS tasks"
}

variable "ecs_max_capacity" {
  type        = number
  default     = 4
  description = "Maximum number of ECS tasks"
}

# ===========================
# Database Configuration
# ===========================
variable "db_name" {
  type        = string
  description = "PostgreSQL database name"
}

variable "db_port" {
  type        = string
  default     = "5432"
  description = "PostgreSQL port"
}
variable "db_password" {
  description = "The database password"
  type        = string
  sensitive   = true
}

variable "db_user" {
  description = "The database user"
  type        = string
}

variable "db_host" {
  description = "The database host"
  type        = string
}

# ===========================
# S3 Configuration
# ===========================
variable "s3_bucket_region" {
  description = "The region of the S3 bucket"
  type        = string
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

# ===========================
# Docker Configuration
# ===========================
variable "docker_username" {
  description = "DockerHub username"
  type        = string
}

variable "docker_password" {
  description = "DockerHub password"
  type        = string
  sensitive   = true
}

variable "local_ip" {
  description = "Your machine's public IP used for DB initialization"
  type        = string
}