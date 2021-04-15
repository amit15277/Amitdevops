resource "aws_security_group" "this" {
  name        = "temp-sg"
  description = "Temp Sg allowed all"
  vpc_id      = var.vpc_id
  //InBound Traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allowed all"
  }
  //OutBound Traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all"
  }
  tags = {
    Name            = var.name
    Environment     = var.ENV
  }
}