data "archive_file" "code_htreadings_bulk_post" {
  type        = "zip"
  output_path = "../code/lambda/htreadings-rds-bulk-post.zip"
  source_dir = "../code/lambda/htreadings-rds-bulk-post/"
}

resource "aws_s3_bucket_object" "lambda_code_s3_obj_bulk" {
  bucket = var.lambda_code_s3
  key    = "htreadings-rds-bulk-post/v1.0.0/htreadings-rds-bulk-post.zip"
  source = "../code/lambda/htreadings-rds-bulk-post.zip"
}

resource "aws_lambda_function" "lambda_htreadings_bulk_post" {
  function_name = "htreadings-bulk-post"
  s3_bucket = var.lambda_code_s3
  s3_key    = "htreadings-rds-bulk-post/v1.0.0/htreadings-rds-bulk-post.zip"
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

 resource "aws_lambda_permission" "apigw_bulk" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.lambda_htreadings_bulk_post.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${var.api_gateway_execution_arn}/*/*"
 }
