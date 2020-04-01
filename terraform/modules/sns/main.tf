resource "aws_sns_topic" "rds" {
  name = "rds-setup"
}

resource "aws_db_event_subscription" "creation" {
  name             = "rds-creation"
  sns_topic        = aws_sns_topic.rds.arn
  source_type      = "db-instance"
  event_categories = ["creation"]
}

resource "aws_sns_topic_subscription" "rds" {
  topic_arn = aws_sns_topic.rds.arn
  protocol  = "lambda"
  endpoint  = var.lambda_init_db_arn
}

resource "aws_lambda_permission" "rds_creation" {
  statement_id   = "AllowExecutionFromSNS"
  action         = "lambda:InvokeFunction"
  function_name  = var.lambda_init_db_function_name
  principal      = "sns.amazonaws.com"
  source_arn     = aws_sns_topic.rds.arn
}