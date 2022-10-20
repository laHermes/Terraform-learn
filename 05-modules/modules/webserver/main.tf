
// ingress for inbound trafic
// from and to port 22
// or range of ports i.e. from_port = 0; to_port = 1000
// cidr_blocks: who is allowed to access
resource "aws_security_group" "myapp-sg" {
  name   = "myapp-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    "Name" = "${var.env_prefix}-sg"
  }
}



// Firewall rules:
// INCOMING (ingress): ssh into ec2 or access from browser
// OUTGOING (egress): installations & fetching docker images

data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = [var.image_name]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



// every user has its own privete key
resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"
  # public_key = "ssh-rsa ********"
  # public_key = OR USE FILE LOCATION "${file("file location" or var.public_key_location)}"
  public_key = var.public_key
}

// localstack create key pair for key_name
resource "aws_instance" "myapp-server" {
  ami                    = data.aws_ami.latest-amazon-linux-image.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]
  availability_zone      = var.avail_zone

  associate_public_ip_address = true

  key_name  = aws_key_pair.ssh-key.key_name
  user_data = file("entry-script.sh")

  tags = {
    "Name" = "${var.env_prefix}-server"
  }
}
