data "aws_ami" "amzn_linux" {
  most_recent = true
  owners      = ["137112412989"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn-ami-hvm-*-gp2"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "template_file" "web_userdata" {
  template = "${file("${path.module}/userdata.tpl")}"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_launch_template" "web" {
  name_prefix            = "web"
  image_id               = "${data.aws_ami.amzn_linux.id}"
  instance_type          = "${var.instance_type}"
  user_data              = "${base64encode(data.template_file.web_userdata.rendered)}"
  vpc_security_group_ids = ["${var.default_sg_id}"]
  key_name               = "${aws_key_pair.deployer.key_name}"

  tag_specifications {
    resource_type = "instance"

    tags {
      Name = "${var.project_name}"
    }
  }
}

resource "aws_autoscaling_group" "web" {
  vpc_zone_identifier       = ["${var.subnet_ids}"]
  max_size                  = "${var.max_elb_pool}"
  min_size                  = "${var.min_elb_pool}"
  health_check_type         = "ELB"
  health_check_grace_period = "${var.health_check_grace_period}"
  load_balancers            = ["${var.load_balancers}"]
  wait_for_capacity_timeout = 0
  wait_for_elb_capacity     = "${var.wait_for_elb_capacity}"

  launch_template = {
    id      = "${aws_launch_template.web.id}"
    version = "$$Latest"
  }
}

resource "aws_autoscaling_notification" "web" {
  group_names   = ["${aws_autoscaling_group.web.name}"]
  notifications = ["autoscaling:EC2_INSTANCE_LAUNCH", "autoscaling:EC2_INSTANCE_TERMINATE"]
  topic_arn     = "${var.autoscale_topic_arn}"
}
