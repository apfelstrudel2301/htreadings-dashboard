data "archive_file" "dotfiles" {
  type        = "zip"
  output_path = "../code/lambda/htreadings-rds-post.zip"
  source_dir = "../code/lambda/htreadings-rds-post/"
}

resource "aws_s3_bucket_object" "s3-object-htreadings-lambda" {
  bucket = var.lambda_code_s3
  key    = "htreadings-rds-post/v1.0.0/htreadings-rds-post.zip"
  source = "../code/lambda/htreadings-rds-post.zip"
}

resource "aws_lambda_function" "htreadings-rds-post-tf" {
  function_name = "htreadings-rds-post-tf"
  s3_bucket = "htreadings-lambda-tf"
  s3_key    = "htreadings-rds-post/v1.0.0/htreadings-rds-post.zip"
  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"
  timeout = 10
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

 resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.htreadings-rds-post-tf.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${var.api_gateway_execution_arn}/*/*"
 }