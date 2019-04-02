provider "aws" {
  access_key = "AKIAJGVKRAMFEYJXNHH"
  secret_key = "/9kR2hyUGw/4xlU70zQHHOuvL6e2qlcc0x/lP+"
  region     = "ap-south-1"
}

#variable "count" {
#default=2
#}

resource "aws_instance" "Amit1" {
#  count = "${var.count}"
  ami           = "ami-03291442a55ad02c1"
  instance_type = "t2.micro"
}

resource "aws_ebs_volume" "volume" {
    availability_zone = "ap-south-1a"
    encrypted = false
    iops = 500
    size = 250
    type = "gp2"
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "dedicated"


  tags {
   Name = "myvpc"
}

}
