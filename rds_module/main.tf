resource "aws_db_instance" "this" {
  allocated_storage    = var.storage_size
  storage_type         = var.storage_type
  engine               = var.db_engine
  engine_version       = var.db_version
  instance_class       = var.db_instanse_size
  identifier           = var.db_identifier
  name                 = var.name
  username             = var.username
  password             = var.password
  parameter_group_name = var.parameter_group_name
  skip_final_snapshot = true
  db_subnet_group_name   = aws_db_subnet_group.this.name
}

resource "aws_db_subnet_group" "this" {

  name_prefix = var.name_prefix
  description = "Database subnet group"
  subnet_ids  = var.subnets

}



