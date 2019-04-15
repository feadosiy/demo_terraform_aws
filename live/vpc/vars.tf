variable "environment" {
  default = "demo"
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "cidr" {
  default = "10.207.2.0/23"
}

variable "secondary_cidr" {
  default = "10.207.4.0/24"
}

variable "azs" {
  description = "Availability zones for environment"
  default     = ["eu-west-1c"]
}
