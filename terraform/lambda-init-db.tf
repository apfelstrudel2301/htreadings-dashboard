data "archive_file" "dbinitfiles" {
  type        = "zip"
  output_path = "../code/lambda/init-db.zip"
  source_dir = "../code/lambda/init-db/"
}

resource "aws_s3_bucket_object" "s3-object-init-db-lambda" {
  bucket = aws_s3_bucket.s3-htreadings-lambda.id
  key    = "init-db/v1.0.0/init-db.zip"
  source = "../code/lambda/init-db.zip"
}

resource "aws_lambda_function" "init-db-tf" {
  function_name = "init-db-tf"
  s3_bucket = "htreadings-lambda-tf"
  s3_key    = "init-db/v1.0.0/init-db.zip"
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
