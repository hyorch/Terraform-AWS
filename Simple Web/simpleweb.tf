# Variables
variable server_port {
    description = "Server port Running httpd"
    default = 8080
    type = number
}

provider "aws" {
  profile = "default" # awscli default profile
  region  = "eu-west-1" #Ireland 
}

resource "aws_instance" "example" {
  ami           = "ami-08bac620dc84221eb" #Ubuntu 20.04
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.tf-simple-web.id] #SG created below
  key_name = "DevOpsAws" # SSH Key
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, TF World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  tags = {
    Name = "tf-Simple Web"
  }
}

resource "aws_security_group" "tf-simple-web" {
  name = "tf-simpe-web"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Outputs
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.example.public_ip
}