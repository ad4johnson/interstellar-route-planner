# ===========================
# RDS PostgreSQL Instance
# ===========================
resource "aws_db_instance" "interstellar_db" {
  # Removed invalid attribute 'vpc_id'
  identifier             = "interstellar-db"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_password
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.rds_access_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.interstellar_subnet_group.name
  multi_az               = false
  port                   = var.db_port
  storage_encrypted      = true

  tags = {
    Name        = "interstellar-db"
    Environment = "production"
    Project     = "interstellar"
  }
}

# ===========================
# RDS Subnet Group
# ===========================
resource "aws_db_subnet_group" "interstellar_subnet_group" {
  name       = "interstellar-db-subnet-group"
  subnet_ids = var.public_subnet_ids

  tags = {
    Name        = "interstellar-db-subnet-group"
    Environment = "production"
    Project     = "interstellar"
  }
}