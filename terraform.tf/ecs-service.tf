resource "aws_ecs_service" "interstellar_service" {
  name            = "interstellar-service"
  cluster         = aws_ecs_cluster.interstellar_cluster.id
  task_definition = aws_ecs_task_definition.interstellar_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = aws_subnet.interstellar_subnet[*].id
    security_groups  = [aws_security_group.interstellar_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.interstellar_tg.arn
    container_name   = "interstellar-container"
    container_port   = 80
  }

  depends_on = [
    aws_lb_listener.http,
    aws_secretsmanager_secret_version.db_secrets_version
  ]
}
