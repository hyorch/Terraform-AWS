terraform {
  backend "s3" {
    # Replace this with your bucket data
    bucket         = "terraform-state-hyorch-devopsaws"   
    key            = "aws01_s3backend/terraform.tfstate"
    region         = "eu-west-1"
  }
}
provider "aws" {
  profile = "default"
  region  = "eu-west-1" #Ireland 
}

resource "aws_instance" "example1S3" {
  ami           = "ami-096f43ef67d75e998"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-00031246"]
  subnet_id              = "subnet-b7b2a5ff"

  tags = {
    Name = "Example with S3 Backend"
  }
}