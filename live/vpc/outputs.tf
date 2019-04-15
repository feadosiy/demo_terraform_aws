output "vpc_id" {
  value = "${module.vpc.id}"
}

output "cidr_block" {
  value = "${module.vpc.cidr_block}"
}

output "secondary_cidr_block" {
  value = "${module.vpc.secondary_cidr_block}"
}

output "default_security_group_id" {
  value = "${module.vpc.default_security_group_id}"
}


output "private_subnets" {
  value = ["${module.vpc.private_subnets}"]
}

output "public_subnets" {
  value = ["${module.vpc.public_subnets}"]
}

output "azs" {
  value = "${var.azs}"
}
