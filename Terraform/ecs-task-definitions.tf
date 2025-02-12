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
      image     = "nginx"
      cpu       = 0
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        {
          name      = "DB_NAME"
          valueFrom = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mysecret:DB_NAME::"
        },
        {
          name      = "DB_USER"
          valueFrom = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mysecret:DB_USER::"
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mysecret:DB_PASSWORD::"
        },
        {
          name  = "DB_HOST"
          value = "postgres-container"
        },
        {
          name  = "DB_PORT"
          value = "5432"
        }
      ]
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
      image     = "postgres:latest"
      cpu       = 0
      essential = true
      portMappings = [
        {
          containerPort = 5432
          hostPort      = 5432
          protocol      = "tcp"
        }
      ]
      environment = [
        {
          name      = "POSTGRES_DB"
          valueFrom = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mysecret:POSTGRES_DB::"
        },
        {
          name      = "POSTGRES_USER"
          valueFrom = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mysecret:POSTGRES_USER::"
        },
        {
          name      = "POSTGRES_PASSWORD"
          valueFrom = "arn:aws:secretsmanager:us-east-1:123456789012:secret:mysecret:POSTGRES_PASSWORD::"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/aws/ecs/postgres-service"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}
