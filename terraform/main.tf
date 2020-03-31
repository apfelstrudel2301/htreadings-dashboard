module "rds" {
  source = "./modules/rds"
}

module "beanstalk" {
  source                    = "./modules/beanstalk"
  rds_db_instance_address   = module.rds.db_instance_address
  rds_db_instance_name      = module.rds.db_instance_name
  rds_db_instance_username  = module.rds.db_instance_username
}

module "api_gateway" {
  source                         = "./modules/api_gateway"
  lambda_single_post_invoke_arn  = module.lambda.lambda_rds_post_invoke_arn
  lambda_bulk_post_invoke_arn    = module.lambda.lambda_rds_bulk_post_invoke_arn
}

module "lambda" {
  source                    = "./modules/lambda"
  rds_db_instance_address   = module.rds.db_instance_address
  rds_db_instance_name      = module.rds.db_instance_name
  rds_db_instance_username  = module.rds.db_instance_username
  api_gateway_execution_arn = module.api_gateway.api_gateway_execution_arn
}