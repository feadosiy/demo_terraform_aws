resource "aws_vpc" "main" {
  cidr_block           = "${var.cidr}"
  enable_dns_hostnames = "${var.enable_dns_hostnames}"
  enable_dns_support   = "${var.enable_dns_support}"
  tags                 = "${merge(var.tags, map("Name", format("%s", var.name)))}"
}

resource "aws_vpc_ipv4_cidr_block_association" "secondary_cidr" {
  vpc_id     = "${aws_vpc.main.id}"
  cidr_block = "${var.secondary_cidr}"

  count = "${var.secondary_cidr == "" ? 0 : 1 }"
}

resource "aws_internet_gateway" "main" {
  vpc_id = "${aws_vpc.main.id}"
  tags   = "${merge(var.tags, map("Name", format("%s-igw", var.name)))}"
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.private_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.private_subnets)}"
  tags              = "${merge(var.tags, var.tags_private_subnet, map("Name", format("%s-subnet-private-%s", var.name, element(var.azs, count.index))))}"
}

resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.main.id}"
  cidr_block        = "${var.public_subnets[count.index]}"
  availability_zone = "${element(var.azs, count.index)}"
  count             = "${length(var.public_subnets)}"
  tags              = "${merge(var.tags, var.tags_public_subnet, map("Name", format("%s-subnet-public-%s", var.name, element(var.azs, count.index))))}"

  map_public_ip_on_launch = "${var.map_public_ip_on_launch}"
  depends_on = ["aws_vpc_ipv4_cidr_block_association.secondary_cidr"]
}

resource "aws_route_table" "public" {
  vpc_id           = "${aws_vpc.main.id}"
  propagating_vgws = ["${var.public_propagating_vgws}"]

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }

  tags = "${merge(var.tags, map("Name", format("%s-rt-public", var.name)))}"
}

resource "aws_route_table" "private" {
  vpc_id           = "${aws_vpc.main.id}"
  propagating_vgws = ["${var.private_propagating_vgws}"]

  count = "${length(var.private_subnets)}"
  tags  = "${merge(var.tags, map("Name", format("%s-rt-private-%s", var.name, element(var.azs, count.index))))}"
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = "${element(aws_route_table.private.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.natgw.*.id, count.index)}"
  count                  = "${var.enable_nat_gateway ? length(var.private_subnets) : 0}"
}

resource "aws_route_table_association" "private" {
  count          = "${length(var.private_subnets)}"
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private.*.id, count.index)}"
}

resource "aws_route_table_association" "public" {
  count          = "${length(var.public_subnets)}"
  subnet_id      = "${element(aws_subnet.public.*.id, count.index)}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_eip" "nateip" {
  vpc   = true
  count = "${var.enable_nat_gateway ? length(var.private_subnets) : 0}"
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = "${element(aws_eip.nateip.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public.*.id, count.index)}"
  count         = "${var.enable_nat_gateway ? length(var.private_subnets) : 0}"

  depends_on = ["aws_internet_gateway.main"]
}

resource "aws_vpc_endpoint" "private_s3" {
  vpc_id       = "${aws_vpc.main.id}"
  service_name = "${var.vpc_endpoints_service_name}"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count = "${length(var.private_subnets)}"

  vpc_endpoint_id = "${aws_vpc_endpoint.private_s3.id}"
  route_table_id  = "${element(aws_route_table.private.*.id, count.index)}"
}
