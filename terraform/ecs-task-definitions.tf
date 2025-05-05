# ===========================
# ECS Task Definition: Interstellar + PostgreSQL (Fargate)
# ===========================
resource "aws_ecs_task_definition" "interstellar_task" {
  family                   = "interstellar-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "interstellar-container"
      image     = var.container_image
      essential = true
      memory    = 1024
      cpu       = 512

      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ],

      command = ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"],

      environment = [
        { name = "DB_HOST", value = var.db_host },
        { name = "DB_PORT", value = var.db_port },
        { name = "DB_NAME", value = var.db_name },
        { name = "DB_USER", value = var.db_user },
        { name = "DB_PASSWORD", value = var.db_password },
        {
          name  = "DATABASE_URL",
          value = "postgresql://${var.db_user}:${var.db_password}@${var.db_host}:${var.db_port}/${var.db_name}"
        }
      ],

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.interstellar_logs.name,
          awslogs-region        = var.aws_region,
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

  tags = {
    Environment = "production"
    Project     = "interstellar"
  }

  depends_on = [aws_db_instance.interstellar_db]
}


# ===========================
# CloudWatch Logs Group (Make sure this exists)
# ===========================
resource "aws_cloudwatch_log_group" "interstellar_logs" {
  name              = "/aws/ecs/interstellar-service"
  retention_in_days = 7
}

# ===========================
# IAM Policy to Access SSM Parameters
# ===========================
resource "aws_iam_role_policy" "ecs_ssm_access" {
  name = "ecs-ssm-access"
  role = aws_iam_role.ecs_task_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = ["ssm:GetParameter"],
        Resource = [
          aws_ssm_parameter.db_password.arn,
          aws_ssm_parameter.db_user.arn,
          aws_ssm_parameter.db_host.arn
        ]
      }
    ]
  })
}