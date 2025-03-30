# Lookup existing VPC
data "aws_vpc" "existing" {
  id = var.vpc_id
}

# Create a new subnet within the VPC
resource "aws_subnet" "main" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
}

# Create an ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name
}

# Create a VPC endpoint for S3
resource "aws_vpc_endpoint" "example" {
  vpc_id       = data.aws_vpc.existing.id
  service_name = var.vpc_endpoint_service_name
  lifecycle {
    ignore_changes = [vpc_id]
  }
}