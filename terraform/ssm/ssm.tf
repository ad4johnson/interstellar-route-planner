terraform {
  backend "s3" {
    bucket         = "the-keyholding-bucket-eu-api"  # Replace with your S3 bucket name
    key            = "terraform/state/interstellar-route-planner.tfstate"  # Path to store the state file
    region         = "us-east-1"  # Replace with your AWS region
    encrypt        = true  # Encrypts the state file
  }
}

# ===============================
# SSM Parameters (Secrets Management)
# ===============================

resource "aws_ssm_parameter" "db_password" {
  name        = "/interstellar/db_password"
  type        = "SecureString"
  value       = var.db_password
  description = "Database password for Interstellar Route Planner"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ssm_parameter" "db_user" {
  name        = "/interstellar/db_user"
  type        = "SecureString"
  value       = var.db_user
  description = "Database user for Interstellar Route Planner"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_ssm_parameter" "db_host" {
  name        = "/interstellar/db_host"
  type        = "SecureString"
  value       = var.db_host
  description = "Database host for Interstellar Route Planner"

  lifecycle {
    create_before_destroy = true
  }
}


# ===============================
# Retrieve Secrets from SSM (Data Sources)
# ===============================

data "aws_ssm_parameter" "db_password" {
  name = "/interstellar/db_password"
}

data "aws_ssm_parameter" "db_user" {
  name = "/interstellar/db_user"
}

data "aws_ssm_parameter" "db_host" {
  name = "/interstellar/db_host"
}


# ===============================
# Database Configuration Variables
# ===============================

variable "db_password" {
  description = "The database password"
  type        = string
  sensitive   = true  # Prevents exposure in logs
}

variable "db_creds" {
  description = "The database credentials (username and password)"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The database name"
  type        = string
}

variable "db_user" {
  description = "The database user"
  type        = string
}

variable "db_host" {
  description = "The database host"
  type        = string
}

variable "db_port" {
  description = "The database port"
  type        = string
}