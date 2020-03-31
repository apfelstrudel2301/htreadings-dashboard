resource "aws_elastic_beanstalk_application" "htreadings-dashboard-tf" {
  name = "htreadings-dashboard-tf"
}

resource "aws_elastic_beanstalk_environment" "htreadings-dashboard-env" {
  name                = "htreadings-dashboard-env"
  application         = aws_elastic_beanstalk_application.htreadings-dashboard-tf.name
  tier                = "WebServer"
  solution_stack_name = "64bit Amazon Linux 2018.03 v2.9.7 running Python 3.6"
  cname_prefix        = "htreadings-dashboard-tf"
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

data "archive_file" "htreadings-server" {
  type        = "zip"
  source_dir = "../code/beanstalk/htreadings-server/"
  output_path = "../code/beanstalk/htreadings-server.zip"
}

resource "aws_s3_bucket" "s3-htreadings-dashboard" {
  bucket = "htreadings-dashboard"
}

resource "aws_s3_bucket_object" "s3-object-htreadings-dashboard" {
  bucket = aws_s3_bucket.s3-htreadings-dashboard.id
  key    = "v1.0.0/htreadings-server.zip"
  source = "../code/beanstalk/htreadings-server.zip"
}

resource "aws_elastic_beanstalk_application_version" "default" {
  name        = "htreadings-dashboard-tf-version"
  application = aws_elastic_beanstalk_application.htreadings-dashboard-tf.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.s3-htreadings-dashboard.id
  key         = aws_s3_bucket_object.s3-object-htreadings-dashboard.id
}
