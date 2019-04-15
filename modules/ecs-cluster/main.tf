
terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

resource "aws_ecs_cluster" "ecs" {
  name = "${var.ecs_cluster_name}"

  tags = "${merge(var.tags, map("Name", format("%s-ecs", var.ecs_cluster_name)))}"
}

resource "aws_launch_configuration" "ecs" {
  name_prefix   = "ecs_${var.ecs_cluster_name}-"
  image_id      = "${var.ecs_ami}"
  instance_type = "${var.ecs_instance_type}"
  key_name      = "${var.admin_key_name}"

  security_groups = ["${aws_security_group.ecs.id}",
    "${var.default_security_group_id}",
  ]

  iam_instance_profile = "${aws_iam_instance_profile.ecs.name}"
  user_data            = "${data.template_cloudinit_config.cloud_config.rendered}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = "${var.root_volume_size}"
    delete_on_termination = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs" {
  name = "ecs-${var.ecs_cluster_name}-asg"

  vpc_zone_identifier = [
    "${var.private_subnets_ids}",
  ]

  launch_configuration = "${aws_launch_configuration.ecs.name}"
  min_size             = "${var.ecs_instance_size_min}"
  max_size             = "${var.ecs_instance_size_max}"
  desired_capacity     = "${var.ecs_instance_size}"
  load_balancers       = ["${var.load_balancers}"]

  termination_policies = "${var.termination_policies}"

}
