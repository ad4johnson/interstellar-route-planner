# Add your variable declarations here

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to filter subnets"
  type        = string
}

# ===========================
# ECS Service Resource
# ===========================
resource "aws_ecs_service" "interstellar_service" {
  name                 = "interstellar-service"
  cluster              = aws_ecs_cluster.interstellar_cluster.id
  task_definition      = aws_ecs_task_definition.interstellar_task.arn
  desired_count        = 2
  launch_type          = "FARGATE"
  force_new_deployment = false # Prevents unnecessary re-creation

  network_configuration {
    subnets          = var.public_subnet_ids   # Reference to the public subnet IDs variable
    security_groups  = [var.security_group_id] # Reference to the security group ID variable
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.interstellar_tg.arn
    container_name   = "interstellar-container"
    container_port   = 80
  }

  depends_on = [aws_lb.interstellar_alb, aws_lb_target_group.interstellar_tg] # Ensure Load Balancer is created first
}

resource "aws_ecs_service" "example" {
  name    = "example-service"
  cluster = aws_ecs_cluster.main.id
  # Other service configuration
}

resource "aws_ecs_cluster" "main" {
  name       = "main-cluster"
  depends_on = [aws_ecs_service.example]
}

# ===========================
# Data Source for Subnets
# ===========================
data "aws_subnets" "existing_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id] # Filter subnets by VPC ID
  }
}


