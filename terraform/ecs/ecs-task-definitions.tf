# ===========================
# PostgreSQL ECS Task Definition
# ===========================
resource "aws_ecs_task_definition" "postgres_task" {
  family                   = "postgres-task"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  volume {
    name = "db-storage"
  }

  container_definitions = jsonencode([
    {
      name      = "postgres-container"
      image     = "postgres:latest"
      essential = true
      portMappings = [
        {
          containerPort = 5432
          hostPort      = 5432
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "S3_BUCKET_NAME", value = var.s3_bucket_name }
      ]
      mountPoints = [
        {
          sourceVolume  = "db-storage"
          containerPath = "/var/lib/postgresql/data"
        }
      ]
      secrets = [
        { name = "POSTGRES_DB", valueFrom = "/interstellar/db_creds/DB_NAME" },
        { name = "POSTGRES_USER", valueFrom = "/interstellar/db_creds/DB_USER" },
        { name = "POSTGRES_PASSWORD", valueFrom = "/interstellar/db_creds/DB_PASSWORD" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/aws/ecs/postgres-service"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

# ===========================
# Interstellar ECS Task Definition
# ===========================
resource "aws_ecs_task_definition" "interstellar_task" {
  family                   = "interstellar-task"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "interstellar-container"
      image     = var.container_image
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "DB_HOST", valueFrom = "/interstellar/db_creds/DB_HOST" },
        { name = "DB_PORT", value = var.db_port }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/aws/ecs/interstellar-service"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}