resource "aws_api_gateway_rest_api" "api_gw" {
  name        = var.api_gw_name
  description = "API for sensordata"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Single POST
resource "aws_api_gateway_resource" "api_gw_res_single" {
   rest_api_id = aws_api_gateway_rest_api.api_gw.id
   parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
   path_part   = var.api_gw_res_path_single
}

resource "aws_api_gateway_method" "api_gw_meth_single" {
   rest_api_id      = aws_api_gateway_rest_api.api_gw.id
   resource_id      = aws_api_gateway_resource.api_gw_res_single.id
   http_method      = "POST"
   authorization    = "NONE"
   api_key_required = true
 }

 resource "aws_api_gateway_integration" "integration_single" {
   rest_api_id = aws_api_gateway_rest_api.api_gw.id
   resource_id = aws_api_gateway_method.api_gw_meth_single.resource_id
   http_method = aws_api_gateway_method.api_gw_meth_single.http_method
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = var.lambda_single_post_invoke_arn
 }

  # Bulk POST
resource "aws_api_gateway_resource" "api_gw_res_bulk" {
   rest_api_id = aws_api_gateway_rest_api.api_gw.id
   parent_id   = aws_api_gateway_rest_api.api_gw.root_resource_id
   path_part   = var.api_gw_res_path_bulk
}

resource "aws_api_gateway_method" "api_gw_meth_bulk" {
   rest_api_id      = aws_api_gateway_rest_api.api_gw.id
   resource_id      = aws_api_gateway_resource.api_gw_res_bulk.id
   http_method      = "POST"
   authorization    = "NONE"
   api_key_required = true
 }

 resource "aws_api_gateway_integration" "integration_bulk" {
   rest_api_id             = aws_api_gateway_rest_api.api_gw.id
   resource_id             = aws_api_gateway_method.api_gw_meth_bulk.resource_id
   http_method             = aws_api_gateway_method.api_gw_meth_bulk.http_method
   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = var.lambda_bulk_post_invoke_arn
 }

resource "aws_api_gateway_deployment" "api_deployment" {
   depends_on  = [
     aws_api_gateway_integration.integration_single,
     aws_api_gateway_integration.integration_bulk
   ]
   rest_api_id = aws_api_gateway_rest_api.api_gw.id
   stage_name  = "int"
 }

resource "aws_api_gateway_usage_plan" "usageplan" {
  name = "sensordata-api-usage-plan"
  api_stages {
    api_id = aws_api_gateway_rest_api.api_gw.id
    stage  = aws_api_gateway_deployment.api_deployment.stage_name
  }
}

resource "aws_api_gateway_api_key" "api_key" {
  name = "sensordata-api-key"
}

resource "aws_api_gateway_usage_plan_key" "main" {
  key_id        = aws_api_gateway_api_key.api_key.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.usageplan.id
}
