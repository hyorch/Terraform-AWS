provider "aws" {
  profile = "default"
  region  = "eu-west-1" #Ireland 
}

resource "aws_instance" "Jenkins" {
  ami      = "ami-08bac620dc84221eb" #Ubuntu 20.04
  instance_type = "t2.micro"
  security_groups = [aws_security_group.sg-jenkins.id] #SG created below
  subnet_id              = "subnet-b7b2a5ff"
  key_name = var.ssh_key_name # SSH Key
  user_data = <<-EOF
              #!/bin/bash
              wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
              sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
              sudo apt update
              sudo apt install openjdk-11-jre-headless
              sudo apt install jenkins
              sudo systemctl start jenkins
              EOF

  

  tags = {
    Name = var.instance_name
  }
}

resource "aws_security_group" "sg-jenkins" {
  name = "jenkins-sg"
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
  egress { #all exits
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


