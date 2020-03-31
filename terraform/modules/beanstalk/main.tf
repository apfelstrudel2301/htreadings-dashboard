resource "aws_elastic_beanstalk_application" "bs_application" {
  name = var.bs_application_name
}

resource "aws_elastic_beanstalk_environment" "bs_env" {
  name                = var.bs_env_name
  application         = aws_elastic_beanstalk_application.bs_application.name
  tier                = "WebServer"
  solution_stack_name = var.bs_env_solution_stack
  cname_prefix        = var.bs_env_name_cname_prefix
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "RDS_ENDPOINT"
    value     = var.rds_db_instance_address
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_NAME"
    value     = var.rds_db_instance_name
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_USERNAME"
    value     = var.rds_db_instance_username
  }
}

data "archive_file" "code_zip" {
  type        = "zip"
  source_dir  = var.bs_code_source
  output_path = var.bs_code_path_zip
}

resource "aws_s3_bucket" "s3_sensordata_dashboard" {
  bucket = var.bs_code_s3_bucket
}

resource "aws_s3_bucket_object" "s3_obj_sensordata_dashboard" {
  bucket = aws_s3_bucket.s3_sensordata_dashboard.id
  key    = var.bs_code_s3_path
  source = var.bs_code_path_zip
}

resource "aws_elastic_beanstalk_application_version" "bs_app_version" {
  name        = var.bs_app_version_name
  application = aws_elastic_beanstalk_application.bs_application.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.s3_sensordata_dashboard.id
  key         = aws_s3_bucket_object.s3_obj_sensordata_dashboard.id
}
