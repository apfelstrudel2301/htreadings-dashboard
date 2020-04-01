resource "aws_db_instance" "sensordata_db" {
  identifier           = var.rds_instance_idntifier
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = var.rds_instance_db_name
  username             = var.rds_instance_db_username
  password             = var.rds_instance_db_pw
  parameter_group_name = "default.mysql5.7"
  delete_automated_backups = true
  deletion_protection      = false
  multi_az                 = false
  skip_final_snapshot      = true
}
