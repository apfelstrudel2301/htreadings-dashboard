data "archive_file" "code_htreadings_single_post" {
  type        = "zip"
  output_path = var.lambda_code_zip
  source_dir  = var.lambda_code
}

resource "aws_s3_bucket_object" "lambda_code_s3_obj_single" {
  bucket = var.lambda_code_s3
  key    = var.lambda_code_s3_path
  source = var.lambda_code_zip
}

resource "aws_lambda_function" "lambda_htreadings_single_post" {
  function_name = var.lambda_name
  s3_bucket = var.lambda_code_s3
  s3_key    = var.lambda_code_s3_path
  handler   = "lambda_function.lambda_handler"
  runtime   = "python3.8"
  timeout   = 10
  vpc_config {
      subnet_ids = ["subnet-b917e6f5", "subnet-5d13f121", "subnet-a1ac1bcb"]
      security_group_ids = ["sg-595bde3e"]
  }
  role = var.lambda_iam_exec_arn
  environment {
    variables = {
      RDS_ENDPOINT = var.rds_db_instance_address
      DB_NAME = var.rds_db_instance_name
      DB_USERNAME = var.rds_db_instance_username
    }
  }
  # depends_on = [aws_iam_role_policy_attachment.example-AWSLambdaVPCAccessExecutionRole]
}

 resource "aws_lambda_permission" "apigw_single" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.lambda_htreadings_single_post.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${var.api_gateway_execution_arn}/*/*"
 }
