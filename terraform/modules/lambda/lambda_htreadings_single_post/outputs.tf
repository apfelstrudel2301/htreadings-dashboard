output "lambda_rds_post_invoke_arn" {
  value = aws_lambda_function.lambda_htreadings_single_post.invoke_arn
}