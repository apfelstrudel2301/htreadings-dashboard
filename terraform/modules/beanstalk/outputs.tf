output "beanstalk_env_name" {
  value = aws_elastic_beanstalk_environment.htreadings-dashboard-env.name
}

output "beanstalk_application_version_name" {
  value = aws_elastic_beanstalk_application_version.default.name
}