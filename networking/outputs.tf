output "default_sg_id" {
  value = "${aws_vpc.vpc.default_security_group_id}"
}

output "db_sg_id" {
  value = "${aws_security_group.db_sg.id}"
}

output "private_subnet_ids" {
  value = ["${aws_subnet.private.*.id}"]
}

output "public_subnet_ids" {
  value = ["${aws_subnet.public.*.id}"]
}

output "selected_av_zone_ids" {
  value = ["${aws_subnet.public.*.availability_zone}"]
}
