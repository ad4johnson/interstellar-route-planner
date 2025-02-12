resource "aws_secretsmanager_secret" "db_password" {
  name = "interstellar-db-password"
}

resource "aws_secretsmanager_secret_version" "db_password_value" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = "London25"
}

resource "aws_secretsmanager_secret" "db_secrets" {
  name        = "interstellar-db-creds"
  description = "Database credentials for Interstellar Route Planner"
}

resource "aws_secretsmanager_secret_version" "db_secrets_version" {
  secret_id = aws_secretsmanager_secret.db_secrets.id
  secret_string = jsonencode({
    DB_NAME     = "interstellar_db"
    DB_USER     = "admin"
    DB_PASSWORD = "London25"
    DB_HOST     = "postgres-container"
    DB_PORT     = "5432"
  })
}
