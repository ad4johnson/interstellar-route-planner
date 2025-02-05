resource "aws_ecs_cluster" "ecs_cluster" {
  name = "interstellar-cluster"
}

resource "aws_ecs_service" "ecs_service" {
  name            = "interstellar-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = ["subnet-00e47d9c39cfaeaf3"]
    security_groups  = ["sg-07c8c59647ab697f1"]
    assign_public_ip = true
  }
}

resource "aws_ecs_task_definition" "ecs_task" {
  family                   = "interstellar-task"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([
    {
      name      = "interstellar-container"
      image     = "your-docker-image" 
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      environment = [
        {
          name  = "DB_HOST"
          value = "your-rds-endpoint.amazonaws.com" # Replace with actual RDS endpoint
        },
        {
          name  = "DB_PORT"
          value = "5432"
        },
        {
          name  = "DB_USER"
          value = "admin"
        },
        {
          name  = "DB_PASSWORD"
          value = "Intersteller" 
        },
        {
          name  = "CACHE_HOST"
          value = "interstellar-cache.xyz123.us-east-1.cache.amazonaws.com" 
        },
        {
          name  = "CACHE_PORT"
          value = "6379"
        }
      ]
    }
  ])
}