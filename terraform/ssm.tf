resource "aws_ssm_parameter" "db_password" {
  name        = "/interstellar/db_password"
  description = "Database password for Interstellar Route Planner"
  type        = "SecureString"
  value       = var.db_password
}

resource "aws_ssm_parameter" "db_creds" {
  name        = "/interstellar/db_creds"
  description = "Database credentials for Interstellar Route Planner"
  type        = "SecureString"
  value = jsonencode({
    DB_NAME     = var.db_name
    DB_USER     = var.db_user
    DB_PASSWORD = var.db_password
    DB_HOST     = var.db_host
    DB_PORT     = var.db_port
  })
}

variable "db_password" {
  description = "The database password"
  type        = string
  default     = ""
}

variable "db_name" {
  description = "The database name"
  type        = string
  default     = ""
}

variable "db_user" {
  description = "The database user"
  type        = string
  default     = ""
}

variable "db_host" {
  description = "The database host"
  type        = string
  default     = ""
}

variable "db_port" {
  description = "The database port"
  type        = string
  default     = ""
}

data "aws_ssm_parameter" "db_password" {
  name            = "/interstellar/db_password"
  with_decryption = true
}
