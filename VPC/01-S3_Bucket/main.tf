# 01- S3 Backend to store VPC tfstatus

provider "aws" {
  profile = "default"
  region  = "eu-west-1" #Ireland 
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-hyorch-vpc"   
}

# Enable versioning so we can see the full revision history of our state files
resource "aws_s3_bucket_versioning" "versioning_enabled" {
  bucket = "terraform-state-hyorch-vpc"
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "aes256_encryption" {
  bucket = "terraform-state-hyorch-vpc"  
  rule {
    apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
    }
  }
}

# To store the own S3 Bucket tfstate in the bucket, add these line after bucket creation and tfstate will be moved
# aws s3 ls terraform-state-hyorch-vpc/s3bucket_s3backend/
terraform {
  backend "s3" {
    # Replace this with your bucket data
    bucket         = "terraform-state-hyorch-vpc"   
    key            = "s3bucket_s3backend/terraform.tfstate"
    region         = "eu-west-1"
  }
}