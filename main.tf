variable "aws_ssh_key_name" {
  type = string
  description = "The name name of an existing SSH key pair to use for the EC2 instance"
}

data "http" "myip" {
  url = "https://ipv4.icanhazip.com"
}

resource "aws_vpc" "csapp" {
  cidr_block = "172.31.0.0/16"
}

resource "aws_subnet" "csapp" {
  vpc_id     = aws_vpc.csapp.id
  cidr_block = "172.31.0.0/20"
}

resource "aws_internet_gateway" "csapp" {
  vpc_id = aws_vpc.csapp.id
}

resource "aws_route_table" "csapp" {
  vpc_id = aws_vpc.csapp.id
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.csapp.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.csapp.id
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.csapp.id
  route_table_id = aws_route_table.csapp.id
}

resource "aws_security_group" "csapp" {
  name   = "csapp"
  vpc_id = aws_vpc.csapp.id

  ingress {
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "csapp" {
  ami                         = "ami-0e040c48614ad1327"
  instance_type               = "t2.micro"
  key_name                    = var.aws_ssh_key_name
  vpc_security_group_ids      = [aws_security_group.csapp.id]
  subnet_id                   = aws_subnet.csapp.id
  associate_public_ip_address = true
  user_data = file("bootstrap")
}

output "instance_public_ip" {
  value = aws_instance.csapp.public_ip
}

output "aws_ssh_key_name" {
  value = var.aws_ssh_key_name
}
