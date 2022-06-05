terraform {
  backend "s3" {
    # Replace this with your bucket data
    bucket = "terraform-state-hyorch-devopsaws"
    key    = "simpleweb_s3backend/terraform.tfstate"
    region = "eu-west-1"
  }
}