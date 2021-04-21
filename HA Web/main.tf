provider "aws" {
  profile = "default" # awscli default profile
  region  = "eu-west-1" #Ireland 
}

# Launch Configuration
resource "aws_launch_configuration" "web-example" {
  image_id      = "ami-08bac620dc84221eb" #Ubuntu 20.04
  instance_type = "t2.micro"
  security_groups = [aws_security_group.sg-instances.id] #SG created below
  key_name = "DevOpsAws" # SSH Key
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World $HOSTNAME !" > index.html
              nohup busybox httpd -f -p "${var.server_port}" &
              EOF
  lifecycle {
    create_before_destroy = true
  }
}

# Get all AVZs from AWS  region (eu-west-1)
data "aws_availability_zones" "all" {}

# Autoscaling Group
resource "aws_autoscaling_group" "asg-example" {
  launch_configuration = aws_launch_configuration.web-example.id
  availability_zones   = data.aws_availability_zones.all.names
  min_size = 2
  max_size = 10

  load_balancers    = [aws_elb.lb-example.name]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

# Clasic Load Balancer
resource "aws_elb" "lb-example" {
  name               = "terraform-asg-example"
  security_groups    = [aws_security_group.sg-elb.id]
  availability_zones = data.aws_availability_zones.all.names

  # Healtch_check Web Servers
  health_check {
    target              = "HTTP:${var.server_port}/"
    interval            = 30
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # This adds a listener for incoming HTTP requests.
  listener {
    lb_port           = var.elb_port
    lb_protocol       = "http"
    instance_port     = var.server_port
    instance_protocol = "http"
  }

}

#EC2 Instances SG
resource "aws_security_group" "sg-instances" {
  name = "terraform-example-instance"

  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ELB Security Group
resource "aws_security_group" "sg-elb" {
  name = "terraform-example-elb"
  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Inbound HTTP from anywhere
  ingress {
    from_port   = var.elb_port
    to_port     = var.elb_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

