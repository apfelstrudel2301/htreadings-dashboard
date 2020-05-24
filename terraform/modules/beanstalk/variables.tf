variable "rds_db_instance_address" {
  type    = string
}

variable "rds_db_instance_name" {
  type    = string
}

variable "rds_db_instance_username" {
  type    = string
}

variable "bs_application_name" {
  type    = string
  default = "sensordata-dashboard"
}

variable "bs_env_name" {
  type    = string
  default = "sensordata-dashboard-env"
}

variable "bs_env_name_cname_prefix" {
  type    = string
  default = "sensordata-dashboard"
}

variable "bs_env_solution_stack" {
  type    = string
  default = "64bit Amazon Linux 2018.03 v2.9.10 running Python 3.6"
}

variable "bs_app_version_name" {
  type    = string
  default = "sensordata-dashboard-int"
}

variable "bs_code_source" {
  type    = string
  default = "../code/beanstalk/htreadings-server/"
}

variable "bs_code_path_zip" {
  type    = string
  default = "../code/beanstalk/htreadings-server.zip"
}

variable "bs_code_s3_path" {
  type    = string
  default = "v1.0.0/htreadings-server.zip"
}

variable "bs_code_s3_bucket" {
  type    = string
  default = "sensordata-dashboard"
}
