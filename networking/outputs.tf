output "default_sg_id" {
  value = "${aws_vpc.vpc.default_security_group_id}"
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}
