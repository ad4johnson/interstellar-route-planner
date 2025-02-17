variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  default     = "interstellar-cluster"
}

variable "ecs_task_cpu" {
  description = "The number of CPU units to allocate to the ECS task"
  type        = string
  default     = "256"
}

variable "ecs_task_memory" {
  description = "The amount of memory (in MiB) to allocate to the ECS task"
  type        = string
  default     = "512"
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "The security group ID assigned to ECS and database"
  type        = string
  default     = "sg-0a6fa3f01fa5e9ad0"  # Replace with your actual SG ID
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks allowed to access ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]  # Change to a more restrictive CIDR for production
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}