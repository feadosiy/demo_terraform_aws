
resource "aws_ecs_task_definition" "ecs_task" {
  family                = "${var.service_name}"
  network_mode          = "bridge"
  container_definitions = "${data.template_file.registry_task.rendered}"

}

resource "aws_ecs_service" "ecs_service" {
  name            = "${var.service_name}"
  cluster         = "${data.terraform_remote_state.ecs.cluster_arn}"
  task_definition = "${aws_ecs_task_definition.ecs_task.arn}"
  iam_role        = "${data.terraform_remote_state.ecs.cluster_iam_role_id}"
  desired_count   = "${var.desired_count}"

  deployment_maximum_percent         = "${var.deployment_maximum_percent}"
  deployment_minimum_healthy_percent = "${var.deployment_minimum_healthy_percent}"

  ordered_placement_strategy = {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy = {
    type  = "spread"
    field = "instanceId"
  }

  load_balancer = {
    elb_name       = "${data.terraform_remote_state.elb.public_name}"
    container_name = "${var.service_name}"
    container_port = 80
  }
}
