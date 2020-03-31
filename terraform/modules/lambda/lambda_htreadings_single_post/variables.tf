variable "rds_db_instance_address" {
  type = string
}

variable "rds_db_instance_name" {
  type = string
}

variable "rds_db_instance_username" {
  type = string
}

variable "api_gateway_execution_arn" {
  type = string
}

variable "lambda_iam_exec_arn" {
  type = string
}

variable "lambda_code_s3" {
  type = string
}

variable "lambda_name" {
  type    = string
  default = "htreadings-single-post"
}

variable "lambda_code" {
  type    = string
  default = "../code/lambda/htreadings-rds-post/"
}

variable "lambda_code_zip" {
  type    = string
  default = "../code/lambda/htreadings-rds-post.zip"
}

variable "lambda_code_s3_path" {
  type    = string
  default = "htreadings-rds-post/v1.0.0/htreadings-rds-post.zip"
}
