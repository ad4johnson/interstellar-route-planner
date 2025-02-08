resource "aws_secretsmanager_secret" "db_password" {
  name = "interstellar-db-password"
}

resource "aws_secretsmanager_secret_version" "db_password_value" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = "London25"
}