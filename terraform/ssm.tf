resource "aws_ssm_parameter" "db_password" {
  name        = "/interstellar/db_password"
  type        = "SecureString"
  value       = var.db_password
  description = "Database password for Interstellar Route Planner"

  lifecycle {
    ignore_changes = [value] # Don't try to recreate it every time
  }
}

resource "aws_ssm_parameter" "db_user" {
  name        = "/interstellar/db_user"
  type        = "SecureString"
  value       = var.db_user
  description = "Database user for Interstellar Route Planner"

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "db_host" {
  name        = "/interstellar/db_host"
  type        = "SecureString"
  value       = var.db_host
  description = "Database host for Interstellar Route Planner"

  lifecycle {
    ignore_changes = [value]
  }
}