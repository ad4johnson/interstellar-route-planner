# ECS Service (Fixed)
resource "aws_ecs_service" "interstellar_service" {
  name            = "interstellar-service"
  cluster         = aws_ecs_cluster.interstellar_cluster.id
  task_definition = aws_ecs_task_definition.interstellar_task.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = ["subnet-00e47d9c39cfaeaf3", "subnet-04b4390b7d6e34c60"]
    security_groups  = ["sg-07c8c59647ab697f1"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.interstellar_tg.arn
    container_name   = "interstellar-container"
    container_port   = 80
  }
}