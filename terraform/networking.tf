# Lookup existing Internet Gateway
data "aws_internet_gateway" "existing_igw" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

# Internet Gateway for Public Access (only create if one doesn't exist)
resource "aws_internet_gateway" "interstellar_igw" {
  count  = length(data.aws_internet_gateway.existing_igw.id) == 0 ? 1 : 0
  vpc_id = var.vpc_id
}

# Public Route Table for Internet Access
resource "aws_route_table" "public_route_table" {
  vpc_id = var.vpc_id
}

# Ensure Public Internet Access via Route Table
resource "aws_route" "public_internet_access" {
  route_table_id         = "rtb-08762f3ab4b604214"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "igw-01b982db1aea1547c"

  lifecycle {
    ignore_changes = [destination_cidr_block, gateway_id]
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = var.public_subnet_ids[0]
  route_table_id = aws_route_table.public_route_table.id
  count = length(data.aws_subnet.existing_subnet_1) == 0 ? 1 : 0
  lifecycle {
    ignore_changes = [subnet_id, route_table_id]
  }
}

resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = var.public_subnet_ids[1]
  route_table_id = aws_route_table.public_route_table.id
  count = length(data.aws_subnet.existing_subnet_2) == 0 ? 1 : 0
  lifecycle {
    ignore_changes = [subnet_id, route_table_id]
  }
}

# Security Group for ECS & Database
resource "aws_security_group" "interstellar_sg" {
  name        = "interstellar-sg"
  description = "Security group for Interstellar ECS & database"
  vpc_id      = var.vpc_id

  # Allow ECS tasks (or trusted Security Groups) to access PostgreSQL
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.security_group_id]  # Restrict DB access to ECS
  }

  # Allow inbound HTTP traffic (API & ALB)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Allow inbound HTTPS traffic (secure API access)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Allow outbound traffic to anywhere (required for Fargate & DB responses)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Use existing subnets instead of creating new ones
data "aws_subnet" "existing_subnet_1" {
  id = "subnet-05e7dc0bf11f2bc06"
}

data "aws_subnet" "existing_subnet_2" {
  id = "subnet-08595d9184fb831c5"
}