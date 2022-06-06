terraform {
  backend "s3" {
    # Replace this with your bucket data
    bucket = "terraform-state-hyorch-devopsaws"
    key    = "lambda01_s3backend/terraform.tfstate"
    region = "eu-west-1"
  }
}