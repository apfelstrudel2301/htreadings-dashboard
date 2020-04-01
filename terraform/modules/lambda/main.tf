module "lambda_init_db" {
  source = "./lambda_init_db"
  lambda_iam_exec_arn       = aws_iam_role.lambda_exec.arn
  lambda_code_s3            = aws_s3_bucket.lambda_code_s3.id
  rds_db_instance_address   = var.rds_db_instance_address
  rds_db_instance_name      = var.rds_db_instance_name
  rds_db_instance_username  = var.rds_db_instance_username
  api_gateway_execution_arn = var.api_gateway_execution_arn
}

module "lambda_htreadings_single_post" {
  source = "./lambda_htreadings_post"
  lambda_iam_exec_arn       = aws_iam_role.lambda_exec.arn
  lambda_code_s3            = aws_s3_bucket.lambda_code_s3.id
  rds_db_instance_address   = var.rds_db_instance_address
  rds_db_instance_name      = var.rds_db_instance_name
  rds_db_instance_username  = var.rds_db_instance_username
  api_gateway_execution_arn = var.api_gateway_execution_arn
  lambda_name               = "htreadings-single-post"
  lambda_code               = "../code/lambda/htreadings-single-post/"
  lambda_code_zip           = "../code/lambda/htreadings-single-post.zip"
  lambda_code_s3_path       = "htreadings-single-post/v1.0.0/htreadings-single-post.zip"
}

module "lambda_htreadings_bulk_post" {
  source = "./lambda_htreadings_post"
  lambda_iam_exec_arn       = aws_iam_role.lambda_exec.arn
  lambda_code_s3            = aws_s3_bucket.lambda_code_s3.id
  rds_db_instance_address   = var.rds_db_instance_address
  rds_db_instance_name      = var.rds_db_instance_name
  rds_db_instance_username  = var.rds_db_instance_username
  api_gateway_execution_arn = var.api_gateway_execution_arn
  lambda_name               = "htreadings-bulk-post"
  lambda_code               = "../code/lambda/htreadings-bulk-post/"
  lambda_code_zip           = "../code/lambda/htreadings-bulk-post.zip"
  lambda_code_s3_path       = "htreadings-bulk-post/v1.0.0/htreadings-bulk-post.zip"
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

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole" {
  role       = "htreadings-rds-post-tf"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
  depends_on = [aws_iam_role.lambda_exec]
}

resource "aws_s3_bucket" "lambda_code_s3" {
  bucket = "htreadings-lambda-tf"
}