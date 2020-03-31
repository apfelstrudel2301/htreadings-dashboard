output "lambda_rds_post_invoke_arn" {
  value = aws_lambda_function.htreadings-rds-post-tf.invoke_arn
}