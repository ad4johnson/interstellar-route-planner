variable "aws_region" {
  description = "The AWS region to deploy to"
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

variable "db_name" {
  description = "The name of the database"
  type        = string
  default     = "interstellar"
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "The ID of the security group"
  type        = string
}