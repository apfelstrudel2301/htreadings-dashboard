 output "api_gateway_deployment_invoke_url" {
  value = aws_api_gateway_deployment.sensordata-api-deployment1.invoke_url
}

 output "api_gateway_api_key_value" {
  value = aws_api_gateway_api_key.apikey.value
}

 output "api_gateway_execution_arn" {
  value = aws_api_gateway_rest_api.sensordata-api-tf.execution_arn
}