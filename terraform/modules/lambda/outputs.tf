output "lambda_rds_post_invoke_arn" {
  value = module.lambda_htreadings_single_post.lambda_rds_post_invoke_arn
}

output "lambda_rds_bulk_post_invoke_arn" {
  value = module.lambda_htreadings_bulk_post.lambda_rds_bulk_post_invoke_arn
}