output "lambda_rds_post_invoke_arn" {
  value = module.lambda_htreadings_single_post.lambda_post_invoke_arn
}

output "lambda_rds_bulk_post_invoke_arn" {
  value = module.lambda_htreadings_bulk_post.lambda_post_invoke_arn # module.lambda_htreadings_bulk_post.lambda_bulk_post_invoke_arn
}

output "lambda_init_db_arn" {
  value = module.lambda_init_db.lambda_init_db_arn
}

output "lambda_init_db_function_name" {
  value = module.lambda_init_db.lambda_init_db_function_name
}

