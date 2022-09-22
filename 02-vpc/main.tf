provider "aws" {
  access_key                  = "test"
  secret_key                  = "test"
  region                      = "us-east-1"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway     = "http://localhost:4566"
    apigatewayv2   = "http://localhost:4566"
    cloudformation = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    dynamodb       = "http://localhost:4566"
    ec2            = "http://localhost:4566"
    es             = "http://localhost:4566"
    elasticache    = "http://localhost:4566"
    firehose       = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kinesis        = "http://localhost:4566"
    lambda         = "http://localhost:4566"
    rds            = "http://localhost:4566"
    redshift       = "http://localhost:4566"
    route53        = "http://localhost:4566"
    s3             = "http://s3.localhost.localstack.cloud:4566"
    secretsmanager = "http://localhost:4566"
    ses            = "http://localhost:4566"
    sns            = "http://localhost:4566"
    sqs            = "http://localhost:4566"
    ssm            = "http://localhost:4566"
    stepfunctions  = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
}

# values assing on terraform apply
# using command line argument terraform apply -var "subnet_cidr_block=10.0.10.0/24"
# BEST PRACTICE - variable files: terraform-dev.tfvars
# terraform apply -var-file terraform-dev.tfvars
variable "subnet_cidr_block" {
  description = "subnet cidr block"
  default = "10.0.10.0/24"
  type = string
}

variable "vpc_cidr_block" {
  description = "vpc cidr block"
  default = "10.0.0.0/16"
  type = string
}

variable "cidr_blocks" {
  description = "cidr blocks for vpc and subnets"
  type = list(string)
}
# reference var.cidr_blocks[0]

resource "aws_vpc" "development-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "development"
  }
}

# resource.variableName.id to reference res id 
resource "aws_subnet" "dev-subnet-1" {
  vpc_id            = aws_vpc.development-vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = "us-east-1a"
  tags = {
    "Name"    = "dev-subnet-1"
    "vpc_env" = "dev"
  }
}

data "aws_vpc" "existing_vpc" {
  default = true
}

# make sure cidr_block doesn't overlap: aws ec2 --endpoint-url=http://localhost:4566 describe-subnets
resource "aws_subnet" "dev-subnet-2" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "172.31.96.0/20"
  availability_zone = "us-east-1a"
  tags = {
    "Name" = "dev-subnet-2"
  }
}

# removing resources can be achieved by removing the block of code associated with the resource -> use this (terraform apply)
# or
# terraform destroy -target aws_subnet.dev-subnet-2

output "dev-vpc-id" {
  value = "aws_vpc.development-vpc.id"
}

output "dev-subnet-id" {
  value = "aws_subnet.dev-subnet-1.id"
}