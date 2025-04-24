
#get latest ubuntu 24.04 ami
data "aws_ami" "latest_ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}


resource "aws_instance" "Jenkins" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = "t3.micro"
  hibernation            = false
  vpc_security_group_ids = [aws_security_group.sg-jenkins.id] #SG created below

  subnet_id = data.aws_subnets.private.ids[0] # Use the first private subnet

  associate_public_ip_address = true

  key_name  = var.ssh_key_name # SSH Key
  user_data = <<-EOF
    #!/bin/bash
    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
      https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
      https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
      /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt-get update
    sudo apt install -y fontconfig openjdk-21-jre
    sudo apt-get install -y jenkins
    sudo systemctl enable jenkins
    sudo snap install aws-cli --classic
  EOF

  iam_instance_profile = aws_iam_instance_profile.jenkins_ec2_profile.name

  tags = {
    Name = var.instance_name
  }
}

# Create a security group for Jenkins
resource "aws_security_group" "sg-jenkins" {
  name = "jenkins-sg"

  dynamic "ingress" {
    for_each = var.input_port_list
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress { #all exits
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


