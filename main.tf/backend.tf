terraform {
  backend "s3" {
    bucket = "the-keyholding-bucket-eu-api"
    key    = "interstellar/terraform.tfstate"
    region = "us-east-1"
  }
}
