# Launch Configuration
resource "aws_launch_configuration" "web-example" {
  image_id        = "ami-08bac620dc84221eb" #Ubuntu 20.04
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.sg-instances.id] #SG created below
  key_name        = var.ssh_key_name                     # SSH Key
  name            = "lc-webserver"
  user_data       = <<-EOF
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
  min_size             = 1
  desired_capacity     = 3
  max_size             = 4

  load_balancers    = [aws_elb.lb-example.name]
  health_check_type = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg-example"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_policy" "my_asg_policy" {
  name                   = "webservers_autoscale_policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.asg-example.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = "60"
  }

}

# Clasic Load Balancer
resource "aws_elb" "lb-example" {
  name               = "terraform-lb-example"
  security_groups    = [aws_security_group.sg-elb.id]
  availability_zones = data.aws_availability_zones.all.names
  tags = {
    Name = "LB-Webserver"
  }

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
