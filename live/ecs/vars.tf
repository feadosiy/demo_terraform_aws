variable "nameservers" {
  description = "Nameserver to DNS names"
  default     = ["127.0.0.1", "AmazonProvidedDNS"]
}

variable "ecs_ami" {
  description = "AWS ECS Optimized AMI."
  default     = "ami-0627e141ce928067c"
}

variable "ecs_instance_type" {
  description = "Instance Type"
  default     = "t2.micro"
}

variable "root_volume_size" {
  description = "Root EBS volume size in Gb"
  default     = "20"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  default     = "demo-cluster"
}

variable "environment" {
  description = "ECS cluster environment name"
  default     = "demo"
}

variable "admin_key_name" {
  description = "SSH key name to launch ECS isntance with"
  default     = "demo"
}

variable "termination_policies" {
  default = [
    "NewestInstance",
  ]
}

variable "ecs_instance_size" {
  default = 1
}

variable "ecs_instance_size_min" {
  default = 1
}

variable "ecs_instance_size_max" {
  default = 2
}
