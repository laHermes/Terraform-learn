resource "aws_vpc" "myapp-vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    "Name" = "${var.env_prefix}-vpc"
  }
}


resource "aws_route_table" "myapp-route-table" {
  vpc_id = aws_vpc.myapp-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    "Name" = "${var.env_prefix}-route-table"
  }
}


// if it is not associated, default table = main table
resource "aws_route_table_association" "a-rtb-subnet" {
  subnet_id      = aws_subnet.myapp-subnet-1.id
  route_table_id = aws_route_table.myapp-route-table.id
}


module "myapp-subnet" {
  source                 = "./modules/subnet"
  subnet_cidr_block      = var.subnet_cidr_block
  avail_zone             = var.avail_zone
  vpc_id                 = aws_vpc.myapp-vpc.vpc_id
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  env_prefix             = var.env_prefix
}


module "myapp-websrver" {
  source        = "./modules/webserver"
  vpc_id        = aws_vpc.myapp-vpc.vpc_id
  instance_type = var.instance_type
  image_name    = var.image_name
  subnet_id     = module.myapp-subnet.subnet.id
  public_key    = "*******"
  avail_zone    = var.avail_zone
  env_prefix    = var.env_prefix
}

variable "vpc_id" {}
variable "my_ip" {}
variable "env_prefix" {}
variable "image_name" {}
variable "public_key" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "default_sg_id" {}
variable "avail_zone" {}
