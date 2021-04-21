#Deploy a Bootstrap server to AWS
provider "aws" {
  profile = "default"
  region  = "eu-west-1" #Ireland 
}

resource "aws_instance" "bootstrap" {
  ami           = "ami-0ffea00000f287d30"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.bootstrap-sg.id] #SG created below  
  key_name = var.ssh_key_name # SSH Key
  #Install Ansible, Terraform, GIT
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install ansible git yum-utils -y    
    sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
    sudo yum -y install terraform
    terraform -install-autocomplete
    EOF

  tags = {
    Name = var.instance_name
  }
}

#allow SSH from Internet. Allow connections to everywhere. 
resource "aws_security_group" "bootstrap-sg" {
  name = "Bootstrap-SecurityGroup"
  egress { #all exit
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
