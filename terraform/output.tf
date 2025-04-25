# outputs.tf

output "api_urls" {
  description = "Public API and documentation endpoints"
  value = {
    backend_api_url  = "http://interstellar-alb-1176058554.us-east-1.elb.amazonaws.com/api"
    backend_docs_url = "http://interstellar-alb-1176058554.us-east-1.elb.amazonaws.com/docs"
    backend_url      = "http://interstellar-alb-1176058554.us-east-1.elb.amazonaws.com"
  }
}

output "ecs_service_info" {
  description = "ECS metadata and IAM roles"
  value = {
    ecs_cluster_name                 = "Sensitive value hidden" # Terraform will hide sensitive output
    interstellar_service_name        = "interstellar-service"
    interstellar_task_definition_arn = "arn:aws:ecs:us-east-1:597088035840:task-definition/interstellar-task:132"
    interstellar_execution_role_arn  = "arn:aws:iam::597088035840:role/ecsExecutionRole"
    interstellar_task_role_arn       = "arn:aws:iam::597088035840:role/ecsTaskRole"
  }
}

output "load_balancer_info" {
  description = "Application Load Balancer Info"
  value = {
    load_balancer_dns = "interstellar-alb-1176058554.us-east-1.elb.amazonaws.com"
  }
}

output "connectivity_info" {
  description = "Detected Public IP Address for DB Access"
  value = {
    my_current_public_ip = "149.71.17.101"
  }
}
