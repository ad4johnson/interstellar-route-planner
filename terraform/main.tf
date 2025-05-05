# ======================================
# Main Terraform File for Fargate-based ECS
# ======================================

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name
}

locals {
  current_ip = "${chomp(data.http.my_ip.response_body)}/32"
}