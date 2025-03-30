variable "vpc_id" {
  description = "The ID of the VPC where resources will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "The ID of the security group to allow PostgreSQL access"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed for HTTP and HTTPS access"
  type        = list(string)
}

# Lookup existing Internet Gateway
data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

# Create Internet Gateway only if one doesn't exist
resource "aws_internet_gateway" "interstellar_igw" {
  count  = data.aws_internet_gateway.existing.id == "" ? 1 : 0
  vpc_id = var.vpc_id
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
}

# Ensure Public Internet Access
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.existing.id != "" ? data.aws_internet_gateway.existing.id : aws_internet_gateway.interstellar_igw[0].id

  lifecycle {
    ignore_changes = [destination_cidr_block, gateway_id]
  }
}

# Associate Public Subnets
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id

  lifecycle {
    ignore_changes = [route_table_id]
  }
}

resource "aws_security_group" "interstellar_sg" {
  name        = "interstellar-sg"
  description = "Security group for Interstellar ECS & database"
  vpc_id      = var.vpc_id

  # PostgreSQL Access for ECS
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.security_group_id]
  }

  # HTTP Access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # HTTPS Access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  # Outbound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}