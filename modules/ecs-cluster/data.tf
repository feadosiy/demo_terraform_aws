data "aws_vpc" "mod" {
  id = "${var.vpc_id}"
}

data "template_file" "cloud_config" {
  template = "${file("${path.module}/templates/cloud-config.tpl")}"

  vars {
    ecs_cluster = "${aws_ecs_cluster.ecs.name}"

    nameservers = "${indent(6, join("\n", data.template_file.custom_nameserver.*.rendered))}"

    post_user_data_script = "${indent(4, var.post_user_data_script)}"
  }
}

data "template_file" "custom_nameserver" {
  template = "nameserver $${nameserver}"

  vars {
    nameserver = "${element(var.nameservers, count.index)}"
  }

  count = "${length(var.nameservers)}"
}

data "template_cloudinit_config" "cloud_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloud_config.rendered}"
  }
}
