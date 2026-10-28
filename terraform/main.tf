provider "aws" {
  region = "ap-south-1" # Mumbai Region
}

# 1. AWS ka default VPC use karna
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

# 2. Security Group (Port 22, 80, 3306)
resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Allow SSH, HTTP, and MySQL traffic"
  vpc_id      = aws_default_vpc.default.id

  # HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # MySQL
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound traffic (Internet access ke liye)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. EC2 Instance Launch
resource "aws_instance" "web_server" {
  ami                    = "ami-03f4878e83fed34e0" # Ubuntu 22.04 LTS (ap-south-1)
  instance_type          = "t2.micro"
  key_name               = "my-aws-key"           # Apna existing AWS Key Pair name yahan dalein
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "Nginx-MySQL-Server"
  }
}
