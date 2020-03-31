# htreadings-aws
Build a dashboard for visualizing humidity and temperature sensor readings (e.g. from a raspberry pi) with AWS infrastructure.

## Prerequesites
- AWS CLI installed and configured
- Terraform installed
- Python / pip installed

## Install AWS infrastructure

Get the python requirements for all Lambda functions in `/code/lambda`

 ```bash
pip install -r requirements.txt --target .
```

 ```bash
cd ../../../terraform
```

Create AWS infrastructure with Terraform

 ```bash
terraform init
```

 ```bash
terraform plan
```

 ```bash
terraform apply
```

Execute the init-db lambda function in AWS to create the htreadings table.

Running `terraform apply` will create the ElasticBeanstalk environment, application and application version for our deployment file but it will not actually deploy the application. For this we need to use the aws cli to update the environment’s application version.
 ```bash
aws --region $REGION elasticbeanstalk update-environment --environment-name $(terraform output beanstalk_env_name) --version-label $(terraform output beanstalk_application_version_name)
```

