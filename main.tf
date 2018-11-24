data "aws_ami" "coreos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CoreOS-stable-*"]
  }

  owners = ["679593333241"]
}

resource "aws_instance" "etcd_cluster" {
  count                  = "${var.etc_nodes}"
  ami                    = "${data.aws_ami.coreos.id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.etcd_sg.id}"]
  user_data              = "${file("cloud-config.yml")}"

  tags = "${merge(var.tags, map("Name", var.etc_nodes > 1 ? format("%s-%d", var.name, count.index+1) : var.name))}"
}

resource "aws_security_group" "etcd_sg" {
  name = "etcd_cluster_sg"

  ingress {
    from_port   = 2379
    to_port     = 2379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 2380
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
