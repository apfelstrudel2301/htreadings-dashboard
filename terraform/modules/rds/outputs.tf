output "db_instance_address" {
  value = aws_db_instance.sensordata-db-tf.address
}

output "db_instance_name" {
  value = aws_db_instance.sensordata-db-tf.name
}

output "db_instance_username" {
  value = aws_db_instance.sensordata-db-tf.username
}