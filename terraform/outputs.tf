 output "api_gateway_deployment_invoke_url" {
  value = module.api_gateway.api_gateway_deployment_invoke_url
}

output "api_gateway_api_key_value" {
  value = module.api_gateway.api_gateway_api_key_value
}

output "beanstalk_application_version_name" {
  value = module.beanstalk.beanstalk_application_version_name
}

output "beanstalk_env_name" {
  value = module.beanstalk.beanstalk_env_name
}