/**
 *
 Plan:

 - create VPC
 - create S3 endpoint
 - create rote table
 - create default security group
 - create DHCP options
 - create NAT
 *
*/

module "vpc" {
  source = "../../modules/vpc"

  name                       = "${var.environment}"
  cidr                       = "${var.cidr}"
  secondary_cidr             = "${var.secondary_cidr}"
  private_subnets            = ["${var.cidr}"]
  public_subnets             = ["${var.secondary_cidr}"]
  azs                        = ["${var.azs}"]
  enable_dns_hostnames       = true
  enable_dns_support         = true
  enable_nat_gateway         = true
  map_public_ip_on_launch    = false
  vpc_endpoints_service_name = "com.amazonaws.${var.aws_region}.s3"

  tags = {
    "Terraform"   = "true"
    "Environment" = "${var.environment}"
  }
}

resource "aws_vpc_dhcp_options" "main" {
  domain_name         = "grb.demo"
  domain_name_servers = ["127.0.0.1", "AmazonProvidedDNS"]
  ntp_servers         = ["127.0.0.1"]
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${module.vpc.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.main.id}"
}
