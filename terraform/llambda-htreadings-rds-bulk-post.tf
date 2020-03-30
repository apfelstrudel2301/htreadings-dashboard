data "archive_file" "htreadings-rds-bulk-post" {
  type        = "zip"
  output_path = "../code/lambda/htreadings-rds-bulk-post.zip"
  source_dir = "../code/lambda/htreadings-rds-bulk-post/"
}

resource "aws_s3_bucket_object" "s3-object-htreadings-lambda-bulk" {
  bucket = aws_s3_bucket.s3-htreadings-lambda.id
  key    = "htreadings-rds-bulk-post/v1.0.0/htreadings-rds-bulk-post.zip"
  source = "../code/lambda/htreadings-rds-bulk-post.zip"
}

resource "aws_lambda_function" "htreadings-rds-bulk-post-tf" {
  function_name = "htreadings-rds-bulk-post-tf"
  s3_bucket = "htreadings-lambda-tf"
  s3_key    = "htreadings-rds-bulk-post/v1.0.0/htreadings-rds-bulk-post.zip"
  handler = "lambda_function.lambda_handler"
  runtime = "python3.8"
  timeout = 10
  vpc_config {
      subnet_ids = ["subnet-b917e6f5", "subnet-5d13f121", "subnet-a1ac1bcb"]
      security_group_ids = ["sg-595bde3e"]
  }
  role = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      RDS_ENDPOINT = aws_db_instance.sensordata-db-tf.address
      DB_NAME = aws_db_instance.sensordata-db-tf.name
      DB_USERNAME = aws_db_instance.sensordata-db-tf.username
    }
  }
  depends_on = [aws_iam_role_policy_attachment.example-AWSLambdaVPCAccessExecutionRole]
}

 resource "aws_lambda_permission" "apigw-bulk" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.htreadings-rds-bulk-post-tf.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.sensordata-api-tf.execution_arn}/*/*"
 }
