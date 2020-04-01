variable "rds_instance_idntifier" {
  type    = string
  default = "sensordata-db"
}

variable "rds_instance_db_name" {
  type    = string
  default = "sensordata"
}

variable "rds_instance_db_username" {
  type    = string
  default = "admin"
}

variable "rds_instance_db_pw" {
  type    = string
  default = "adminadmin"
}
