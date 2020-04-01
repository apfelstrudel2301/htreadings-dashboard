data "archive_file" "code_db_init" {
  type        = "zip"
  output_path = "../code/lambda/init-db.zip"
  source_dir = "../code/lambda/init-db/"
}

resource "aws_s3_bucket_object" "lambda_code_s3_obj" {
  bucket = var.lambda_code_s3
  key    = "init-db/v1.0.0/init-db.zip"
  source = "../code/lambda/init-db.zip"
}

resource "aws_lambda_function" "init_db" {
  function_name = "init-db"
  s3_bucket = var.lambda_code_s3
  s3_key    = "init-db/v1.0.0/init-db.zip"
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
