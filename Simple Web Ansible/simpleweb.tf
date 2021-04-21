resource "aws_instance" "simple-web" {
  ami           = "ami-08bac620dc84221eb" #Ubuntu 20.04
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.simple-web.id] #SG created below
  key_name = "DevOpsAws" # SSH Key  
  

  tags = {
    Name = "Simple Web TF+Ansible"
  }

  #Install Python in the remote machine
  provisioner "remote-exec" { 
    inline = ["sudo apt-get -qq install python3 -y"]
    connection {
      host        = aws_instance.simple-web.public_ip
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("~/.ssh/DevOpsAWS.pem")}"
    }
  }

  # Run Ansible to install Apache on created VM
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu -i '${aws_instance.simple-web.public_ip}', --private-key ~/.ssh/DevOpsAWS.pem apache.yml"
  }

}

resource "aws_security_group" "simple-web" {
  name = "Simple-web TF+Ansible"
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
  egress { #all exit
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Variables
variable server_port {
    description = "Server port Running Apache"
    default = 80
    type = number
}

provider "aws" {
  profile = "default" # awscli default profile
  region  = "eu-west-1" #Ireland 
}

#Outputs
output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.simple-web.public_ip
}