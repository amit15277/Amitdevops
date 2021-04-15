variable "instance_type" {
  default = "t2.micro"
}
variable "ssh_pubkey_file" {
  description = "Path to an SSH public key"
  default     = "~/.ssh/id_rsa.pub"
}
variable asg_min {
  default = 2
}
variable asg_max {
  default = 4
}
variable asg_desired {
  default = 3
}
variable "ENV" {
  default     = "NON-PROD"
  description = "provide envirnment like prod,non-prod,dr.you can overide this when inheriting this module"
}

variable "subnets" {
  description = "provide list of subnet ids"
  type = list(string)
}
variable "security_groups" {
  description = "provide list of Security groups"
  type = list(string)
}
variable "name" {
  description = "provide name for your tags"
}
variable "alb_arn" {
  description = "provide name for your tags"
}
