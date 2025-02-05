variable "aws_region" {
  default = "us-east-1"
}

variable "ecs_cluster_name" {
  default = "interstellar-cluster"
}

variable "app_name" {
  default = "interstellar-route-planner"
}

variable "db_instance_class" {
  default = "db.t3.micro"
}

variable "db_name" {
  default = "interstellar"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "SecurePassword123!"
}

variable "container_port" {
  default = 8000
}
