# ==============================
# Auto Scaling Target for ECS Service
# ==============================
resource "aws_appautoscaling_target" "ecs_scaling_target" {
  max_capacity       = var.ecs_max_capacity
  min_capacity       = var.ecs_min_capacity
  resource_id        = "service/${aws_ecs_cluster.interstellar_cluster.name}/${aws_ecs_service.interstellar_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# ==============================
# CPU Utilization Scaling Policy
# ==============================
resource "aws_appautoscaling_policy" "ecs_cpu_policy" {
  name               = "ecs-cpu-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 60.0 # Target CPU utilization percentage
    scale_in_cooldown  = 120  # Cooldown period (in seconds) after scaling in
    scale_out_cooldown = 60   # Cooldown period (in seconds) after scaling out
  }
}

# ==============================
# Memory Utilization Scaling Policy (Optional)
# ==============================
resource "aws_appautoscaling_policy" "ecs_memory_policy" {
  name               = "ecs-memory-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_scaling_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_scaling_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = 70.0 # Target memory utilisation percentage
    scale_in_cooldown  = 180  # Cooldown period (in seconds) after scaling in
    scale_out_cooldown = 90   # Cooldown period (in seconds) after scaling out
  }
}