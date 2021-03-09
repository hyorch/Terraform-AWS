provider "aws" {
  profile = "default"
  region  = "eu-west-1" #Ireland  
}

resource "aws_instance" "example1" {
  ami           = "ami-096f43ef67d75e998"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-00031246"]
  subnet_id              = "subnet-b7b2a5ff"

  tags = {
    Name = "Example1 v2"
  }
}