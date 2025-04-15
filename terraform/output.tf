output "load_balancer_dns" {
  value       = aws_lb.interstellar_alb.dns_name
  description = "The DNS name of the Application Load Balancer"
}

output "interstellar_service_name" {
  value = aws_ecs_service.interstellar_service.name
}

output "ecs_cluster_name" {
  value     = aws_ecs_cluster.main.name
  sensitive = true
}

output "backend_url" {
  value       = "http://${aws_lb.interstellar_alb.dns_name}"
  description = "Public URL of the Interstellar backend via ALB"
}

output "backend_api_url" {
  value       = "http://${aws_lb.interstellar_alb.dns_name}/api"
  description = "Public URL of the Interstellar backend API via ALB"
}
output "interstellar_task_definition_arn" {
  value       = aws_ecs_task_definition.interstellar_task.arn
  description = "The ARN of the Interstellar ECS task definition"
}
output "interstellar_task_role_arn" {
  value       = aws_iam_role.ecs_task_role.arn
  description = "The ARN of the ECS task role"
}
output "interstellar_execution_role_arn" {
  value       = aws_iam_role.ecs_execution_role.arn
  description = "The ARN of the ECS execution role"
}
output "backend_docs_url" {
  value       = "http://${aws_lb.interstellar_alb.dns_name}/docs"
  description = "Public URL of the Interstellar backend documentation via ALB"
}