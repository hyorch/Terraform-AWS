resource "aws_instance" "simple-web" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.tf-simple-web.id] #SG created below
  key_name               = "DevOpsAWS"                           # SSH Key
  user_data              = <<-EOF
              #!/bin/bash
              echo "Hello, TF World" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  tags = {
    Name = "tf-Simple Web Ubuntu"
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
    from_port   = var.server_ssh_port
    to_port     = var.server_ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

