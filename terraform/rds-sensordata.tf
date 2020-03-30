resource "aws_db_instance" "sensordata-db-tf" {
  identifier = "sensordata-db-tf"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "sensordatatf"
  username             = "admin"
  password             = "adminadmin"
  parameter_group_name = "default.mysql5.7"
  delete_automated_backups = true
  deletion_protection = false
  multi_az = false
  # vpc_security_group_ids = ["sg-595bde3e"]
  skip_final_snapshot = true
}
