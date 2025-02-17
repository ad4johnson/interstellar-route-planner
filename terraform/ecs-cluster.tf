# ECS Cluster
resource "aws_ecs_cluster" "interstellar_cluster" {
  name = "interstellar-cluster"
}

# Optional: ECS Cluster Definition
resource "aws_ecs_cluster" "main" {
  name = "my-ecs-cluster"
}

