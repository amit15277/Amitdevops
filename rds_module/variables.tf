variable storage_size {
    default = 20
}
variable storage_type {
    default = "gp2"
}
variable db_identifier {
    default = "terraformrds"
}
variable db_engine {
    default = "mysql"
}
variable db_version {
    default = "5.7"
}

variable name {}
variable username {}
variable password {}

variable parameter_group_name {
    default = "default.mysql5.7"
}

variable db_instanse_size {
    default = "db.t2.micro"
}

variable subnets {}
variable name_prefix {}