/**
 * Provides internal access to container ports
 */
resource "aws_security_group" "ecs" {
  name        = "${format("ecs-%s-init-sg", var.ecs_cluster_name)}"
  description = "Container Instance Allowed Ports"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
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

  tags   = "${merge(var.tags, map("Name", format("%s-sg", var.ecs_cluster_name)))}"
}
