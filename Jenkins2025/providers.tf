provider "aws" {
  profile = "HyorchAdmin"  # AWS SSO Profile
  region  = "eu-south-2"
}

# backend s3
terraform {
  backend "s3" {
    bucket         = "hyorch-terraform"
    key            = "jenkins2025/terraform.tfstate"
    region         = "eu-south-2"

    profile = "HyorchAdmin"
  }
}
