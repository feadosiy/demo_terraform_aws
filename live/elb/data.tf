data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "ecs-demo-terraform-state"
    key    = "live/vpc/terraform"
    region = "eu-west-1"
  }
}
