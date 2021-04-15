variable "ENV" {
  default     = "NON-PROD"
  description = "provide envirnment like prod,non-prod,dr.you can overide this when inheriting this module"
}


variable "http_ports" {
  description = "provide list of http listner ports.default is 80"
  type    = list(string)
  default = ["80"]
}

variable tg_port {
  default = 80
}

variable "lb_name" {
  description = "provide load balancer name"
}

variable "lb_timeout" {
  description = "provide load balancer timeout value"
  default = "60"
}

variable "lb_internal" {
  description = "provide true if load balancer is internal else false for external LB"
  default = "true"
}



variable "build_http_listeners" {
  description = "boolean if http listner required or not"
  default = "true"
}

variable "security_groups" {
  description = "provide list of Security groups"
  type = list(string)
}

variable "subnets" {
  description = "provide list of subnet ids"
  type = list(string)
}


variable "uri_path" {
  type    = list(string)
  default = []
}

variable "port_map" {
  type    = map(string)
  default = {}
}
variable "vpc_id" {}
variable "http_listner_rule_enabled" {
  default = "true"
}

variable "https_listner_rule_enabled" {
  default = "true"
}

