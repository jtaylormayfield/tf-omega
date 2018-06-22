resource "aws_db_subnet_group" "default" {
  subnet_ids = ["${var.subnet_ids}"]

  tags {
    Name = "${var.project_name}"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage      = "${var.storage_gb}"
  db_subnet_group_name   = "${aws_db_subnet_group.default.name}"
  vpc_security_group_ids = ["${var.sg_ids}"]
  storage_type           = "${var.storage_type}"
  engine                 = "${var.engine}"
  engine_version         = "${var.engine_version}"
  instance_class         = "${var.class}"
  name                   = "${var.name}"
  username               = "${var.username}"
  password               = "${var.password}"

  tags {
    Name = "${var.project_name}"
  }
}
