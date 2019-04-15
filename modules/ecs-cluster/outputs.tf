output "cluster_name" {
  description = "ECS cluster name"
  value       = "${aws_ecs_cluster.ecs.name}"
}

output "cluster_arn" {
  description = "ECS cluster arn"
  value       = "${aws_ecs_cluster.ecs.arn}"
}

output "cluster_iam_role_id" {
  description = "IAM role id assigned to ecs-host. Can be expanded by add new policy."
  value       = "${aws_iam_role.ecs.id}"
}

output "sg_id" {
  description = "ECS cluster security group id"
  value       = "${aws_security_group.ecs.id}"
}

output "sg_name" {
  description = "ECS cluster security group name"
  value       = "${aws_security_group.ecs.name}"
}

output "asg_group_name" {
  description = "Autoscaling group name"
  value       = "${aws_autoscaling_group.ecs.name}"
}
