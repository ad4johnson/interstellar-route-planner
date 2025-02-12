aws_region        = "us-east-1" # Change if needed
ecs_cluster_name  = "interstellar-cluster"
ecs_task_cpu      = "256"
ecs_task_memory   = "512"
db_name           = "interstellar"
vpc_id            = "vpc-0ebf59b186a59f2bc"
public_subnet_ids = ["subnet-xxxxxxxx", "subnet-0be0bb5dbf80b057d"]
security_group_id = "sg-0a6fa3f01fa5e9ad0"