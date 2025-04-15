# ===========================
# RDS PostgreSQL Instance
# ===========================
resource "aws_db_instance" "interstellar_db" {
  identifier             = "interstellar-db"
  engine                 = "postgres"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  db_name                = var.db_name
  username               = var.db_user
  password               = var.db_password
  skip_final_snapshot    = true
  publicly_accessible    = true
  vpc_security_group_ids = [var.security_group_id]
  db_subnet_group_name   = aws_db_subnet_group.interstellar_subnet_group.name
  multi_az               = false
  port                   = var.db_port

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

# ===========================
# OPTIONAL: Database Initialization
# You can remove this block once DB is created manually
# ===========================
resource "null_resource" "init_db" {
  provisioner "local-exec" {
    command = <<EOT
  export PGPASSWORD="${var.db_password}" && \
  psql -h ${var.db_host} \
       -p ${var.db_port} \
       -U ${var.db_user} \
       -d postgres \
       -tc "SELECT 1 FROM pg_database WHERE datname = '${var.db_name}'" | grep -q 1 || \
  psql -h ${var.db_host} \
       -p ${var.db_port} \
       -U ${var.db_user} \
       -d postgres \
       -c "CREATE DATABASE ${var.db_name};"
EOT

  }

  depends_on = [aws_db_instance.interstellar_db]
  triggers = {
    always_run = timestamp() # Forces this to rerun when db is recreated
  }
}