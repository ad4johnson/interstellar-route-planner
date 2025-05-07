
# ===========================================
# Public Subnets
# ===========================================
data "aws_vpc" "main" {
  id = var.vpc_id
}


resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.public_subnet_azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "interstellar-public-subnet-${count.index}"
  }
}

# ===========================================
# Internet Gateway
# ===========================================
data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}


# ===========================================
# Public Route Table
# ===========================================
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "interstellar-public-rt"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.existing.id
}

# ===========================================
# Associate Subnets to Route Table
# ===========================================
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(aws_subnet.public[*].id)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# ===========================================
# Security Group
# ===========================================
resource "aws_security_group" "interstellar_sg" {
  name        = "interstellar-sg"
  description = "Security group for Interstellar ECS & database"
  vpc_id      = var.vpc_id

  # PostgreSQL Access for ECS service
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    self        = true # ✅ Allow traffic from itself
    description = "Allow PostgreSQL access from ECS tasks in same SG"
  }


  # PostgreSQL Access for local machine
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [local.current_ip]
    description = "Allow local access to PostgreSQL"
  }

  # HTTP Access for API
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [local.current_ip]
    description = "Allow HTTP access"
  }

  # HTTPS Access (optional future use)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.current_ip]
    description = "Allow HTTPS access"
  }

  # All outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_alb_to_ecs" {
  type                     = "ingress"
  from_port                = 8000
  to_port                  = 8000
  protocol                 = "tcp"
  security_group_id        = aws_security_group.interstellar_sg.id              # ECS SG
  source_security_group_id = tolist(aws_lb.interstellar_alb.security_groups)[0] # ALB SG
  description              = "Allow ALB to access ECS on port 8000"
}