// http://docs.aws.amazon.com/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
variable "ecs_ami" {
  description = "AWS ECS Optimized AMI."
  default     = "ami-644a431b"
}

variable "ecs_instance_type" {
  description = "Instance Type"
  default     = "t2.micro"
}

variable "ecs_instance_size" {
  description = "ECS cluster desired capacity"
  default     = "1"
}

variable "ecs_instance_size_min" {
  description = "ECS cluster min capacity"
  default     = "1"
}

variable "ecs_instance_size_max" {
  description = "ECS cluster max capacity"
  default     = "2"
}

variable "root_volume_size" {
  description = "Root EBS volume size in Gb"
  default     = "20"
}

variable "ecs_cluster_name" {
  description = "ECS cluster name"
  default     = "default"
}

variable "admin_key_name" {
  description = "SSH key name to launch ECS isntance with"
}

variable "default_security_group_id" {
  description = "Default security group id"
}

variable "private_subnets_ids" {
  description = "List of private subnets"
  type        = "list"
}

variable "vpc_id" {
  description = "VPC id"
}

variable "nameservers" {
  default = []
}

variable "load_balancers" {
  default = []
}

variable "termination_policies" {
  default = [
    "Default"
  ]
}

variable "post_user_data_script" {
  default = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  default     = {}
}
