resource "aws_cloudwatch_metric_alarm" "ecs_task_failures" {
  alarm_name          = "ECS-Task-Failures"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "TaskCount"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Triggers if ECS task failures exceed threshold"
  actions_enabled     = true
  alarm_actions       = [aws_sns_topic.ecs_alerts.arn]

  dimensions = {
    ClusterName = aws_ecs_cluster.interstellar_cluster.name
    ServiceName = aws_ecs_service.interstellar_service.name
  }
}

resource "aws_sns_topic" "ecs_alerts" {
  name = "ecs-failure-alerts"
}

resource "aws_sns_topic_subscription" "ecs_email_alert" {
  topic_arn = aws_sns_topic.ecs_alerts.arn
  protocol  = "email"
  endpoint  = "a_j1408@hotmail.com"
}