terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "ap-southeast-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "example" {
  instance_type     = "r5d.2xlarge"
  ami               = "${data.aws_ami.ubuntu.id}"
  availability_zone = "ap-southeast-1c"

  key_name = "zuhlke_mac"
  user_data = "${file("install_elk_podman.sh")}"

  root_block_device = {
    volume_type           = "gp2"
    volume_size           = 40
    delete_on_termination = true
  }

  tags {
    type = "test"
  }
}

resource "aws_ebs_volume" "storage" {
  availability_zone = "${aws_instance.example.availability_zone}"
  size  = 80
}

resource "aws_volume_attachment" "storage_attachement" {
  device_name = "/dev/sdh"
  volume_id   = "${aws_ebs_volume.storage.id}"
  instance_id = "${aws_instance.example.id}"
}
