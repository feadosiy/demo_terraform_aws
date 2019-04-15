data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "ecs-demo-terraform-state"
    key    = "live/vpc/terraform"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "ecs" {
  backend = "s3"

  config {
    bucket = "ecs-demo-terraform-state"
    key    = "live/ecs/terraform"
    region = "eu-west-1"
  }
}

data "terraform_remote_state" "elb" {
  backend = "s3"

  config {
    bucket = "ecs-demo-terraform-state"
    key    = "live/elb/terraform"
    region = "eu-west-1"
  }
}

data "template_file" "registry_task" {
  template = "${file("${path.module}/templates/task.json")}"

  vars {
    name   = "${var.service_name}"
    docker_image   = "${var.docker_image}"
  }
}
