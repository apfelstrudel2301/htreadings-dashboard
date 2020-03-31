variable "lambda_rds_post_invoke_arn" {
  type    = string
}

variable "lambda_rds_bulk_post_invoke_arn" {
  type    = string
}

variable "api_gw_name" {
  type    = string
  default = "sensordata-api"
}

variable "api_gw_res_path_single" {
  type    = string
  default = "htreadings-single"
}

variable "api_gw_res_path_bulk" {
  type    = string
  default = "htreadings-bulk"
}
