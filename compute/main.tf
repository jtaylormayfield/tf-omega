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

resource "aws_instance" "web" {
  ami                    = "${data.aws_ami.amzn_linux.id}"
  instance_type          = "${var.instance_type}"
  user_data              = "${data.template_file.web_userdata.rendered}"
  vpc_security_group_ids = ["${var.default_sg_id}"]
  key_name               = "${aws_key_pair.deployer.key_name}"
  subnet_id              = "${var.subnet}"

  tags {
    Name = "${var.project_name}-1"
  }
}
