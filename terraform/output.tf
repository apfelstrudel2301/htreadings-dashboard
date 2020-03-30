 output "base_url" {
  value = aws_api_gateway_deployment.sensordata-api-deployment1.invoke_url
}

output "api-key" {
  value = aws_api_gateway_api_key.apikey.value
}

output "app_version" {
  value = aws_elastic_beanstalk_application_version.default.name
}

output "env_name" {
  value = aws_elastic_beanstalk_environment.htreadings-dashboard-env.name
}