terraform {
  backend "s3" {
    bucket = "ecs-demo-terraform-state"
    key    = "live/elb/terraform"
    region = "eu-west-1"
    dynamodb_table = "ecs-demo-locks"
  }
}
