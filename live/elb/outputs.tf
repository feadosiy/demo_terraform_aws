output "public_name" {
  value = "${aws_elb.public.name}"
}

output "public_dns_name" {
  value = "${aws_elb.public.dns_name}"
}
