LOCALSTACK uses port 4556 as specified in docker compose file

list all s3 buckets: aws --endpoint-url=http://localhost:4566 s3 ls
copy this file to a bucket: aws --endpoint-url=http://localhost:4566 s3 cp test.txt s3://my-bucket
list bucket objects: aws --endpoint-url=http://localhost:4566 s3 ls s3://my-bucket
run this to empty my-bucket: aws --endpoint-url=http://localhost:4566 s3 rm s3://my-bucket --recursive

1. terraform init -> to initialize terraform
2. terraform plan -> to compare tf changes
3. terraform apply -> to apply changes
4. terraform destroy -> destroys all resources defined in tf file


aws ec2 --endpoint-url=http://localhost:4566 describe-vpcs
aws ec2 --endpoint-url=http://localhost:4566 describe-subnets