resource "aws_vpc" "vpc" {
  cidr_block = "${var.vpc_cidr}"

  tags {
    Name = "${var.project_name}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.project_name}"
  }
}

resource "aws_default_route_table" "private" {
  default_route_table_id = "${aws_vpc.vpc.default_route_table_id}"

  tags {
    Name = "${var.project_name}-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }

  tags {
    Name = "${var.project_name}-public"
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "private" {
  count             = "${var.num_private_subnets}"
  vpc_id            = "${aws_vpc.vpc.id}"
  availability_zone = "${element(data.aws_availability_zones.available.names, count.index)}"
  cidr_block        = "${cidrsubnet(var.rt_private_cidr, var.num_private_subnets, count.index)}"

  tags {
    Name = "${var.project_name}-private-${count.index + 1}"
  }
}

resource "aws_subnet" "public" {
  count                   = "${var.num_public_subnets}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  availability_zone       = "${element(data.aws_availability_zones.available.names, count.index)}"
  map_public_ip_on_launch = true
  cidr_block              = "${cidrsubnet(var.rt_public_cidr, var.num_public_subnets, count.index)}"

  tags {
    Name = "${var.project_name}-public-${count.index + 1}"
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = "${aws_subnet.private.*.id[count.index]}"
  route_table_id = "${aws_vpc.vpc.default_route_table_id}"
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = "${aws_subnet.public.*.id[count.index]}"
  route_table_id = "${aws_route_table.public.id}"
}

resource "aws_default_security_group" "default_sg" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    protocol  = 6
    self      = true
    from_port = 80
    to_port   = 80
  }

  ingress {
    protocol  = 6
    self      = true
    from_port = 22
    to_port   = 22
  }

  egress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }
}
