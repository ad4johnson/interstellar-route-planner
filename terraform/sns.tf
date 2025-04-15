resource "aws_sns_topic" "alerts" {
  name = "interstellar-ecs-failure-alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "a_j1408@hotmail.com"
}