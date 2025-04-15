# ======================================
# Main Terraform File for Fargate-based ECS
# ======================================

# Lookup existing VPC
data "aws_vpc" "existing" {
  id = var.vpc_id
}

# Lookup existing subnets
data "aws_subnet" "public" {
  for_each = toset(var.public_subnet_ids)
  id       = each.value
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name
}