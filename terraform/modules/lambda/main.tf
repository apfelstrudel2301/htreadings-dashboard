module "lambda_init_db" {
  source = "./lambda_init_db"
  rds_db_instance_address   = var.rds_db_instance_address
  rds_db_instance_name      = var.rds_db_instance_name
  rds_db_instance_username  = var.rds_db_instance_username
  api_gateway_execution_arn = var.api_gateway_execution_arn
  lambda_iam_exec_arn       = aws_iam_role.lambda_exec.arn
  lambda_code_s3            = aws_s3_bucket.s3-htreadings-lambda.id
}

module "lambda_htreadings_single_post" {
  source = "./lambda_htreadings_single_post"
  rds_db_instance_address   = var.rds_db_instance_address
  rds_db_instance_name      = var.rds_db_instance_name
  rds_db_instance_username  = var.rds_db_instance_username
  api_gateway_execution_arn = var.api_gateway_execution_arn
  lambda_iam_exec_arn       = aws_iam_role.lambda_exec.arn
  lambda_code_s3            = aws_s3_bucket.s3-htreadings-lambda.id
}

module "lambda_htreadings_bulk_post" {
  source = "./lambda_htreadings_bulk_post"
  rds_db_instance_address   = var.rds_db_instance_address
  rds_db_instance_name      = var.rds_db_instance_name
  rds_db_instance_username  = var.rds_db_instance_username
  api_gateway_execution_arn = var.api_gateway_execution_arn
  lambda_iam_exec_arn       = aws_iam_role.lambda_exec.arn
  lambda_code_s3            = aws_s3_bucket.s3-htreadings-lambda.id
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

resource "aws_s3_bucket" "s3-htreadings-lambda" {
  bucket = "htreadings-lambda-tf"
}