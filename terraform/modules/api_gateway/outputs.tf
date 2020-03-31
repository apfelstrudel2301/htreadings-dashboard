 output "api_gateway_deployment_invoke_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}

 output "api_gateway_api_key_value" {
  value = aws_api_gateway_api_key.api_key.value
}

 output "api_gateway_execution_arn" {
  value = aws_api_gateway_rest_api.api_gw.execution_arn
}