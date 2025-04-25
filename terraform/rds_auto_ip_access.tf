# rds_auto_ip_access.tf

# Fetch your current public IP dynamically
data "http" "my_ip" {
  url = "https://api.ipify.org"
}

# Add a security group allowing your IP for PostgreSQL (port 5432)
resource "aws_security_group" "rds_access_sg" {
  name        = "allow-postgres-from-my-ip"
  description = "Allow PostgreSQL access from my public IP"
  vpc_id      = data.aws_vpc.existing.id # <-- or aws_vpc.main.id if you used resource


  ingress {
    description = "PostgreSQL Access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_ip.response_body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "rds-access-from-my-ip"
  }
}

resource "aws_security_group_rule" "allow_ecs_to_rds" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_access_sg.id   # your RDS security group
  source_security_group_id = aws_security_group.interstellar_sg.id # your ECS service security group
  description              = "Allow ECS tasks to access RDS"
}