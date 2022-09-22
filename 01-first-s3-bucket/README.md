01-first-s3-bucket

LOCALSTACK uses port 4556 as specified in docker compose file

list all s3 buckets: aws --endpoin-url=http://localhost:4566 s3 ls
copy this file to a bucket: aws --endpoint-url=http://localhost:4566 s3 cp test.txt s3://my-bucket
list bucket objects: aws --endpoint-url=http://localhost:4566 s3 ls s3://my-bucket

1. terraform init
2. terraform plan
3. terraform apply

4. run this to empty my-bucket: aws --endpoint-url=http://localhost:4566 s3 rm s3://my-bucket --recursive
5. terraform destroy
