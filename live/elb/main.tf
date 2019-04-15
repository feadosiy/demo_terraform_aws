resource "aws_lb_cookie_stickiness_policy" "public" {
  name                     = "DemoELBStickiness"
  load_balancer            = "${aws_elb.public.id}"
  lb_port                  = 80
  cookie_expiration_period = 3600
}

resource "aws_elb" "public" {
  name     = "demo"
  subnets  = ["${data.terraform_remote_state.vpc.public_subnets}"]
  internal = false

  security_groups = [
    "${aws_security_group.elb.id}",
  ]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 2
    target              = "HTTP:80/login"
    interval            = 20
  }

  cross_zone_load_balancing   = false
  idle_timeout                = 60
  connection_draining         = false
  connection_draining_timeout = 300

}

resource "aws_security_group" "elb" {
  name        = "Demo-ELBSecurityGroup"
  description = "SecurityGroup for ELB"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0",
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
