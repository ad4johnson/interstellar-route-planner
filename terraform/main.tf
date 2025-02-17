data "aws_vpc" "existing" {
  id = "vpc-0ebf59b186a59f2bc" # Replace with your actual VPC ID
}

resource "aws_subnet" "main" {
  vpc_id                  = "vpc-0ebf59b186a59f2bc"
  cidr_block              = "192.168.192.0/24" # Updated CIDR block
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_instance" "web" {
  ami           = "ami-01e3c4a339a264cc9"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
}

resource "aws_vpc_endpoint" "example" {
  vpc_id       = data.aws_vpc.existing.id
  service_name = "com.amazonaws.us-east-1.s3"

  lifecycle {
    ignore_changes = [vpc_id]
  }
}