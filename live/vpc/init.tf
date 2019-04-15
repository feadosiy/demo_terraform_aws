terraform {
  backend "s3" {
    bucket = "ecs-demo-terraform-state"
    key    = "live/vpc/terraform"
    region = "eu-west-1"
    dynamodb_table = "ecs-demo-locks"
  }
}
