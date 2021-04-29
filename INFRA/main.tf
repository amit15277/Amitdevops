terraform {

  #required_version = "0.14.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


provider "aws" {
  region  = "ap-south-1"
  profile = "default"
}

module "vpc_module" {
  source                 = "../vpc_module"
  vpc_cidr               = "172.17.80.0/23"
  public_cidrs           = ["172.17.80.0/27", "172.17.80.32/27"]
  private_cidrs          = ["172.17.80.128/25", "172.17.81.0/25"]
  az                     = ["ap-south-1a", "ap-south-1b"]
  name                   = "Demo-test"
  private_subnets_per_az = "1"
  nat_gw_count = "1"
  ENV =  "Demo"
}

module "alb_module" {
  source    = "../alb_module"
  lb_name   = "tomcat-lb"
  security_groups = [module.sg.sg]
  subnets = [element( module.vpc_module.private_subnet_id ,0),element( module.vpc_module.private_subnet_id,1)]
  vpc_id = module.vpc_module.vpc_id
  build_http_listeners = "true"
  http_listner_rule_enabled = "false"
  tg_port = "8080"
}
module "alb_module_ext" {
  source    = "../alb_module"
  lb_name   = "web-lb"
  security_groups = [module.sg.sg]
  subnets = [element( module.vpc_module.public_subnet_id ,0),element( module.vpc_module.public_subnet_id,1)]
  vpc_id = module.vpc_module.vpc_id
  build_http_listeners = "true"
  http_listner_rule_enabled = "false"
  lb_internal = false
}
module "asg_tomcat" {
    source = "../asg_module"
    name                   = "tomcat-asg"
    subnets = [element( module.vpc_module.private_subnet_id ,0),element( module.vpc_module.private_subnet_id,1)]
    security_groups = [module.sg.sg]
    alb_arn = module.alb_module.tg_arn
}

module "asg_web" {
    source = "../asg_module"
    name                   = "web-asg"
    subnets = [element( module.vpc_module.private_subnet_id ,0),element( module.vpc_module.private_subnet_id,1)]
    security_groups = [module.sg.sg]
    alb_arn = module.alb_module_ext.tg_arn
}

module "sg" {
    source = "../sg"
    vpc_id = module.vpc_module.vpc_id
    name   = "Demo-test"
}
data "aws_ssm_parameter" "dummyref" {
  name = "secretdemo"
}
module "rds" {
  source = "../rds_module"
  name = "testdb"
  username = "dbadmin"
  password = data.aws_ssm_parameter.dummyref.value
  db_instanse_size = "db.t2.micro"
  name_prefix = "test"
  subnets = [element( module.vpc_module.private_subnet_id ,0),element( module.vpc_module.private_subnet_id,1)]
  
 
}


resource "aws_subnet" "my_subnet" {
  vpc_id            = module.vpc_module.vpc_id
  cidr_block        = "172.17.80.64/27"
  availability_zone = "ap-south-1a"
  
  tags = {
    Name = "tf-example"
  }
}

resource "aws_route_table" "rt" {
 vpc_id = module.vpc_module.vpc_id
 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = "${element(module.vpc_module.internet_gw_id, 0)}"
 }
}
 
resource "aws_route_table_association" "test" {
 subnet_id      = aws_subnet.my_subnet.id
 route_table_id = aws_route_table.rt.id
}

variable "privatekey"{

  default = "AmitWin"

}

resource "aws_instance" "Amit1" {
  
 ami           = "ami-0a9d27a9f4f5c0efc"
 instance_type = "t2.micro"
 key_name = "AmitWin"
 associate_public_ip_address = true
 subnet_id   = aws_subnet.my_subnet.id
 vpc_security_group_ids = [aws_security_group.all_http.id, aws_security_group.all_ssh.id]
 #depends_on = [module.vpc_module.internet_gw_id]
 tags = {
    Name = "Amit1"
  }
 provisioner "remote-exec" {
    inline = [
      "sudo yum upate -y",
      "sudo yum install nginx",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx",
    ]

 connection {
   host = self.public_ip
   type = "ssh"
   user = "ec2-user"
   private_key = file("~/.ssh/AmitWin.pem")
  }
}

#provisioner "local-exec" {
#    command = "ansible-playbook -i ${aws_instance.Amit1.public_ip} --private-key ${var.privatekey} nginx.yml"
#  }
#}


 provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.Amit1.public_ip} --private-key ${var.privatekey} nginx.yml"
  }
}


resource "aws_security_group" "all_http" {
 name        = "allow_http"
 description = "Allow HTTP traffic"
 vpc_id      = module.vpc_module.vpc_id
 ingress {
   description = "HTTP"
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_security_group" "all_ssh" {
 name        = "allow_ssh"
 description = "Allow SSH traffic"
 vpc_id      = module.vpc_module.vpc_id
 ingress {
   description = "SSHC"
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}
