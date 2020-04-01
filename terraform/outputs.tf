 output "api_gateway_invoke_url" {
  value = module.api_gateway.api_gateway_deployment_invoke_url
}

output "api_gateway_api_key" {
  value = module.api_gateway.api_gateway_api_key_value
}

# output "beanstalk_application_version_name" {
#   value = module.beanstalk.beanstalk_application_version_name
# }

# output "beanstalk_env_name" {
#   value = module.beanstalk.beanstalk_env_name
# }

output "init_db_command" {
  value = "aws lambda invoke --function-name ${module.lambda.lambda_init_db_function_name} output.json"
}

output "beanstalk_command" {
  value = "aws elasticbeanstalk update-environment --environment-name ${module.beanstalk.beanstalk_env_name} --version-label ${module.beanstalk.beanstalk_application_version_name}"
}