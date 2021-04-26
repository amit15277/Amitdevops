######## networking/variables.tf

variable "vpc_cidr" {
  description = "provide cidr block of your vpc"
}

variable "public_cidrs" {
  type        = list(string)
  description = "provide list of public subnet cidrs"
  default     = [""]
}



variable "private_cidrs" {
  type        = list(string)
  description = "provide list of private subnet cidrs"
  default     = [""]
}

variable "private_subnets_per_az" {
  default = "1"
}


variable "nat_gw_count" {
  default     = "0"
  description = "provide count for nat gateway.you can overide this when inheriting this module"
}

variable "name" {
  description = "provide name for your tags"
}

variable "ENV" {
  default     = "NON-PROD"
  description = "provide envirnment like prod,non-prod,dr.you can overide this when inheriting this module"
}

variable "az" {
  type        = list(string)
  description = "provide list of aws availability zones.you can overide this when inheriting this module"
}

