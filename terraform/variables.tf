# ===========================
# General AWS Configuration
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
  description = "Memory allocation for ECS tasks (MB)"
  type        = number
  default     = 2048
}

variable "ecs_min_capacity" {
  description = "Minimum number of ECS tasks"
  type        = number
  default     = 1
}

variable "ecs_max_capacity" {
  description = "Maximum number of ECS tasks"
  type        = number
  default     = 4
}

# ===========================
# Networking Configuration
# ===========================

# VPC ID for the existing VPC
variable "vpc_id" {
  description = "The ID of the existing VPC to use for the infrastructure"
  type        = string
}

# VPC CIDR block (optional unless required elsewhere)
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

# (Optional) VPC Endpoint Service Name
variable "vpc_endpoint_service_name" {
  description = "The name of the VPC endpoint service"
  type        = string
}

# Public subnet CIDRs
variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

# Availability Zones for public subnets
variable "public_subnet_azs" {
  description = "List of Availability Zones for public subnets"
  type        = list(string)
}

# Public route table ID
variable "route_table_id" {
  description = "The ID of the Route Table for the public subnets"
  type        = string
}

# Internet Gateway ID
variable "gateway_id" {
  description = "The ID of the Internet Gateway to use"
  type        = string
}

# Allowed inbound CIDR blocks (optional)
variable "allowed_cidr_blocks" {
  description = "The CIDR blocks allowed for inbound access (optional)"
  type        = list(string)
  default     = []
}

# ===========================
# ECS Task Definition Configuration
# ===========================
variable "container_image" {
  description = "The container image for the Interstellar application"
  type        = string
}

variable "interstellar_image_version" {
  description = "The version tag of the Interstellar Docker image"
  type        = string
  default     = "1.0.0"
}

# ===========================
# Database Configuration
# ===========================
variable "db_name" {
  description = "PostgreSQL database name"
  type        = string
}

variable "db_user" {
  description = "PostgreSQL username"
  type        = string
}

variable "db_password" {
  description = "PostgreSQL password (stored securely)"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "PostgreSQL database host endpoint"
  type        = string
}

variable "db_port" {
  description = "PostgreSQL database port"
  type        = string
  default     = "5432"
}

# ===========================
# S3 Configuration
# ===========================
variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "s3_bucket_region" {
  description = "Region where the S3 bucket is hosted"
  type        = string
}

# ===========================
# DockerHub Configuration
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