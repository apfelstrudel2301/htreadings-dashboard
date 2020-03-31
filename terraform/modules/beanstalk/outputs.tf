output "beanstalk_env_name" {
  value = aws_elastic_beanstalk_environment.bs_env.name
}

output "beanstalk_application_version_name" {
  value = aws_elastic_beanstalk_application_version.bs_app_version.name
}