data "archive_file" "dotfiles" {
  type        = "zip"
  output_path = "../code/lambda/htreadings-rds-post.zip"
  source_dir = "../code/lambda/htreadings-rds-post/"
}

resource "aws_s3_bucket" "s3-htreadings-lambda" {
  bucket = "htreadings-lambda-tf"
}

resource "aws_s3_bucket_object" "s3-object-htreadings-lambda" {
  bucket = aws_s3_bucket.s3-htreadings-lambda.id
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

  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      RDS_ENDPOINT = var.rds_db_instance_address
      DB_NAME = var.rds_db_instance_name
      DB_USERNAME = var.rds_db_instance_username
    }
  }
  depends_on = [aws_iam_role_policy_attachment.example-AWSLambdaVPCAccessExecutionRole]
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "htreadings-rds-post-tf"
  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Action": "sts:AssumeRole",
       "Principal": {
         "Service": "lambda.amazonaws.com"
       },
       "Effect": "Allow",
       "Sid": ""
     }
   ]
 }
 EOF

}

resource "aws_iam_role_policy_attachment" "example-AWSLambdaVPCAccessExecutionRole" {
  role       = "htreadings-rds-post-tf"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  depends_on = [aws_iam_role.lambda_exec]
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
