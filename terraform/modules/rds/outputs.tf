output "db_instance_address" {
  value = aws_db_instance.sensordata_db.address
}

output "db_instance_name" {
  value = aws_db_instance.sensordata_db.name
}

output "db_instance_username" {
  value = aws_db_instance.sensordata_db.username
}