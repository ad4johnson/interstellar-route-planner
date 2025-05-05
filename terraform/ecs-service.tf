resource "aws_ecs_service" "interstellar_service" {
  name            = "interstellar-service"
  cluster         = aws_ecs_cluster.interstellar_cluster.id
  task_definition = aws_ecs_task_definition.interstellar_task.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.interstellar_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.interstellar_tg.arn
    container_name   = "interstellar-container"
    container_port   = 8000
  }

  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 60

  enable_ecs_managed_tags = true
  propagate_tags          = "SERVICE"

  tags = {
    Environment = "production"
    Project     = "interstellar"
  }

  lifecycle {
    ignore_changes = [task_definition] # Optional: prevents forced updates unless changed
  }

  depends_on = [
    aws_lb_listener.http
  ]
}