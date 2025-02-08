resource "aws_vpc" "interstellar_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "interstellar_subnet" {
  vpc_id     = aws_vpc.interstellar_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "interstellar_sg" {
  name        = "interstellar-sg"
  description = "Security group for interstellar ECS & database"
  vpc_id      = aws_vpc.interstellar_vpc.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}