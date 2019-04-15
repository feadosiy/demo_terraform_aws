resource "aws_iam_role" "ecs" {
  name_prefix        = "ecs-role-${var.ecs_cluster_name}"
  assume_role_policy = "${file("${path.module}/iam_policy/ecs-role.json")}"
}

/* ecs service scheduler role */
resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "${var.ecs_cluster_name}-ecs_service_role_policy"
  policy = "${file("${path.module}/iam_policy/ecs-service-role-policy.json")}"
  role   = "${aws_iam_role.ecs.id}"
}

/* ec2 container instance role & policy */
resource "aws_iam_role_policy" "ecs_instance_role_policy" {
  name   = "${var.ecs_cluster_name}-ecs_instance_role_policy"
  policy = "${file("${path.module}/iam_policy/ecs-instance-role-policy.json")}"
  role   = "${aws_iam_role.ecs.id}"
}

resource "aws_iam_instance_profile" "ecs" {
  name = "${var.ecs_cluster_name}-ecs_profile"
  role = "${aws_iam_role.ecs.name}"
}
