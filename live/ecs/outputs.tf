output "environment" {
  value = "${var.environment}"
}

output "cluster_name" {
  value = "${module.ecs.cluster_name}"
}

output "cluster_iam_role_id" {
  value = "${module.ecs.cluster_iam_role_id}"
}

output "cluster_arn" {
  value = "${module.ecs.cluster_arn}"
}
