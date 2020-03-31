output "lambda_rds_post_invoke_arn" {
  value = aws_lambda_function.htreadings-rds-post-tf.invoke_arn
}

output "lambda_rds_bulk_post_invoke_arn" {
  value = aws_lambda_function.htreadings-rds-bulk-post-tf.invoke_arn
}