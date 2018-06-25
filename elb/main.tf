resource "aws_elb" "main" {
  name            = "${var.project_name}"
  security_groups = ["${var.security_groups}"]
  subnets         = ["${var.subnets}"]

  access_logs {
    bucket        = "${var.log_bucket}"
    bucket_prefix = "${var.log_bucket_prefix}"
    interval      = 60
  }

  listener {
    instance_port     = "${var.instance_port}"
    instance_protocol = "${var.instance_protocol}"
    lb_port           = "${var.lb_port}"
    lb_protocol       = "${var.lb_protocol}"
  }

  health_check {
    healthy_threshold   = "${var.healthy_checks}"
    unhealthy_threshold = "${var.unhealthy_checks}"
    timeout             = "${var.timeout}"
    target              = "TCP:${var.instance_port}"
    interval            = "${var.interval}"
  }

  tags {
    Name = "${var.project_name}"
  }
}
