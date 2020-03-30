resource "aws_api_gateway_rest_api" "sensordata-api-tf" {
  name        = "sensordata-api-tf"
  description = "API for sensordata"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

 resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.sensordata-api-tf.id
   parent_id   = aws_api_gateway_rest_api.sensordata-api-tf.root_resource_id
   path_part   = "htreadings-rds"
}

resource "aws_api_gateway_method" "proxy" {
   rest_api_id   = aws_api_gateway_rest_api.sensordata-api-tf.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "POST"
   authorization = "NONE"
   api_key_required = true
 }

 resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.sensordata-api-tf.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.htreadings-rds-post-tf.invoke_arn
 }

  # Bulk
  resource "aws_api_gateway_resource" "proxy-bulk" {
   rest_api_id = aws_api_gateway_rest_api.sensordata-api-tf.id
   parent_id   = aws_api_gateway_rest_api.sensordata-api-tf.root_resource_id
   path_part   = "htreadings-rds-bulk"
}

resource "aws_api_gateway_method" "proxy-bulk" {
   rest_api_id   = aws_api_gateway_rest_api.sensordata-api-tf.id
   resource_id   = aws_api_gateway_resource.proxy-bulk.id
   http_method   = "POST"
   authorization = "NONE"
   api_key_required = true
 }

 resource "aws_api_gateway_integration" "lambda-bulk" {
   rest_api_id = aws_api_gateway_rest_api.sensordata-api-tf.id
   resource_id = aws_api_gateway_method.proxy-bulk.resource_id
   http_method = aws_api_gateway_method.proxy-bulk.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.htreadings-rds-bulk-post-tf.invoke_arn
 }


 resource "aws_api_gateway_deployment" "sensordata-api-deployment1" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda-bulk
   ]

   rest_api_id = aws_api_gateway_rest_api.sensordata-api-tf.id
   stage_name  = "test-stage"
 }

 resource "aws_api_gateway_usage_plan" "usageplan" {
  name = "sensordata-api-tf-usage-plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.sensordata-api-tf.id
    stage  = aws_api_gateway_deployment.sensordata-api-deployment1.stage_name
  }
}

resource "aws_api_gateway_api_key" "apikey" {
  name = "sensordata-api-tf"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.apikey.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usageplan.id
}
