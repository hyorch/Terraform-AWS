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
  tags = {
	 Name = "sg-Webserver"
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
  tags = {
	 Name = "sg-elb"
 }
}