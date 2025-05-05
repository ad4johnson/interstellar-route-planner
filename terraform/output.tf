# ================================
# Application Load Balancer URLs
# ================================
output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer (ALB)"
  value       = aws_lb.interstellar_alb.dns_name
}

output "alb_http_url" {
  description = "Public HTTP endpoint of the API (root)"
  value       = "http://${aws_lb.interstellar_alb.dns_name}"
}

output "alb_docs_url" {
  description = "Public HTTP endpoint of the API Docs (/docs)"
  value       = "http://${aws_lb.interstellar_alb.dns_name}/docs"
}

# ================================
# ECS Service Details
# ================================
output "ecs_cluster_name" {
  description = "ECS Cluster Name"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "ECS Service Name"
  value       = aws_ecs_service.interstellar_service.name
}

output "ecs_task_definition_arn" {
  description = "ECS Task Definition ARN"
  value       = aws_ecs_task_definition.interstellar_task.arn
}

output "ecs_execution_role_arn" {
  description = "ECS Execution IAM Role ARN"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "ECS Task IAM Role ARN"
  value       = aws_iam_role.ecs_task_role.arn
}

# ================================
# Connectivity (Database Access IP)
# ================================
output "my_current_public_ip" {
  description = "Your current detected public IP (for RDS security group)"
  value       = local.current_ip
}