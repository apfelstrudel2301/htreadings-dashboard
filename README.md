# htreadings-aws
Build a dashboard for visualizing humidity and temperature sensor readings (e.g. from a raspberry pi) with AWS infrastructure.

## Prerequesites
- AWS CLI installed and configured
- Terraform installed
- Python / pip installed

## Getting started

### Install AWS infrastructure

#### Create AWS infrastructure with Terraform

To create the AWS infrastructure with Terraform execute the following commands.
 ```bash
cd terraform
```

 ```bash
terraform init
```

 ```bash
terraform plan
```

 ```bash
terraform apply
```
#### Ouputs of the terraform script
- **init_db_command**: The command to invoke the init-db lambda function, which creates the database table
- **beanstalk_command**: The command to deploy the beanstalk application
- **api_gateway_invoke_url**: API base URL, there will be a `POST /htreadings-single` and a `POST /htreadings-bulk` endpoint
- **api_gateway_api_key**: API key needed to use the API

### Initialize database

Execute the init-db lambda function in AWS to create the htreadings database table.
This command is displayed as an output of the terraform scripts.

 ```
aws lambda invoke --function-name init-db lambda_out.json
```

### Deploy beanstalk application

Running `terraform apply` will create the ElasticBeanstalk environment, application and application version for our deployment file but it will not actually deploy the application. For this we need to use the aws cli to update the environment’s application version.
This command is displayed as an output of the terraform scripts.

 ```bash
aws elasticbeanstalk update-environment --environment-name $(terraform output beanstalk_env_name) --version-label $(terraform output beanstalk_application_version_name)
```
The command will output the `CNAME` attribute. This is the URL under which the dashboard will be reachable.

## AWS infrastructure

The terraform script is creating the following infrastructure:
- API Gateway with the following endpoints:
    - POST /htreadings-single
    - POST /htreadings-single
- Lambda functions
    - Two lambda functions to process the API requests
    - One lambda function to initialize the database
- RDS database to store the sensordata for the schema please have a look at init-db lambda function at `/code/lambda/init-db/lambda_function.py`
- Beanstalk application: for hosting the dashboard that is showing the sensordata

All the infrastucture created should be with the AWS free tier (without giving any guarantees).

