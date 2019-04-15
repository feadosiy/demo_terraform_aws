
resource "aws_key_pair" "demo" {
  key_name = "demo"
  public_key = "${file("../../nonpublic/demo.pub")}"
}


module "ecs" {
  source = "../../modules/ecs-cluster"

  ecs_cluster_name      = "${var.ecs_cluster_name}"
  ecs_ami               = "${var.ecs_ami}"
  ecs_instance_type     = "${var.ecs_instance_type}"
  ecs_instance_size     = "${var.ecs_instance_size}"
  ecs_instance_size_min = "${var.ecs_instance_size_min}"
  ecs_instance_size_max = "${var.ecs_instance_size_max}"
  root_volume_size      = "${var.root_volume_size}"

  vpc_id                    = "${data.terraform_remote_state.vpc.vpc_id}"
  private_subnets_ids       = "${data.terraform_remote_state.vpc.private_subnets}"
  default_security_group_id = "${aws_security_group.ecs.id}"
  admin_key_name            = "${var.admin_key_name}"
  termination_policies      = "${var.termination_policies}"

  nameservers           = "${var.nameservers}"

  tags = {
    "Terraform"   = "true"
    "Environment" = "${var.environment}"
  }
}

resource "aws_autoscaling_policy" "up" {
  name = "${format("scale-up-%s", module.ecs.cluster_name)}"

  scaling_adjustment = 2

  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = "${module.ecs.asg_group_name}"
}

resource "aws_cloudwatch_metric_alarm" "up" {
  alarm_name          = "DemoClusterScaleUpAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Maximum"
  threshold           = "80"
  treat_missing_data  = "notBreaching"

  dimensions {
    ClusterName = "${module.ecs.cluster_name}"
  }

  alarm_description = "CPU Reservation peaked at 80% during the last minute"
  alarm_actions     = ["${aws_autoscaling_policy.up.arn}"]
}

resource "aws_autoscaling_policy" "down" {
  name = "${format("scale-down-%s", module.ecs.cluster_name)}"

  scaling_adjustment     = -50
  cooldown               = 120
  adjustment_type        = "PercentChangeInCapacity"
  autoscaling_group_name = "${module.ecs.asg_group_name}"
}

resource "aws_cloudwatch_metric_alarm" "down" {
  alarm_name          = "DemoClusterScaleDownAlarm"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = "1200"
  statistic           = "Maximum"
  threshold           = "40"
  treat_missing_data  = "notBreaching"

  dimensions {
    ClusterName = "${module.ecs.cluster_name}"
  }

  alarm_description = "CPU Reservation is under 40% for the last 20 min"
  alarm_actions     = ["${aws_autoscaling_policy.down.arn}"]
}

resource "aws_security_group" "ecs" {
  name        = "${format("ecs-%s-sg", var.ecs_cluster_name)}"
  description = "Container Instance Allowed Ports"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [
      "${data.terraform_remote_state.vpc.secondary_cidr_block}",
    ]
  }

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "${data.terraform_remote_state.vpc.cidr_block}",
      "${data.terraform_remote_state.vpc.secondary_cidr_block}",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name        = "ecs-${var.ecs_cluster_name}-sg"
    Terraform   = "true"
    Environment = "${var.environment}"
  }
}
