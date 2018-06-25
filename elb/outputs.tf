output "default_lb" {
  value = "${aws_elb.main.id}"
}

output "public_dns" {
  value = "${aws_elb.main.dns_name}"
}

output "instance_ids" {
  value = "${aws_elb.main.instances}"
}
