# ECS Task Definition - Interstellar App
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
      image     = "ad4johnson/interstellar-route-planner:v1.1" # Hardcoded version
      cpu       = 0
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name  = "DB_NAME"
          value = "your_db_name"
        },
        {
          name  = "DB_USER"
          value = "your_db_user"
        },
        {
          name  = "DB_PASSWORD"
          value = "your_db_password"
        },
        {
          name  = "DB_HOST"
          value = "your_db_host"
        },
        {
          name  = "DB_PORT"
          value = "5432"
        }
      ]
      secrets = []
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


# ECS Task Definition - PostgreSQL
resource "aws_ecs_task_definition" "postgres_task" {
  family                   = "interstellar-postgres-task"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "postgres-container"
      image     = "postgres:14" # Specifying version to ensure stability
      cpu       = 0
      essential = true
      portMappings = [
        {
          containerPort = 5432
          hostPort      = 5432
          protocol      = "tcp"
        }
      ]
      environment = []
      secrets = [
        {
    name      = "DB_PASSWORD"
    valueFrom = data.aws_ssm_parameter.db_password.arn
        },
        {
          name      = "POSTGRES_DB"
          valueFrom = "/interstellar/db_creds/DB_NAME"
        },
        {
          name      = "POSTGRES_USER"
          valueFrom = "/interstellar/db_creds/DB_USER"
        },
        {
          name      = "POSTGRES_PASSWORD"
          valueFrom = "/interstellar/db_creds/DB_PASSWORD"
        }
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