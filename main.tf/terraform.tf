resource "aws_dynamodb_table" "hyperspace_gates" {
  name         = "HyperspaceGates"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }
}

resource "aws_ecr_repository" "ecr_repo" {
  name = "interstellar-route-planner"
}