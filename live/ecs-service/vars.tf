variable "service_name" {
  description = "Name of the service"
  default     = "nginxdemos"
}

variable "desired_count" {
  description = "Desired count of service instances"
  default     = 1
}

variable "deployment_maximum_percent" {
  default = 200
}

variable "deployment_minimum_healthy_percent" {
  default = 100
}

variable "docker_image" {
  default = "nginxdemos/hello"
}
