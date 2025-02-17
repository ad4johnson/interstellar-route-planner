resource "aws_ecs_service" "interstellar_service" {
  name            = "interstellar-service"
  cluster         = aws_ecs_cluster.interstellar_cluster.id
  task_definition = aws_ecs_task_definition.interstellar_task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.public_subnet_ids
    security_groups  = [var.security_group_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.interstellar_tg.arn
    container_name   = "interstellar-container"
    container_port   = 80
  }

  depends_on = [aws_lb.interstellar_alb] # Ensure Load Balancer is created first
}