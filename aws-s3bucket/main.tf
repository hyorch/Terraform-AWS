provider "aws" {
  profile = "default"
  region  = "eu-west-1" #Ireland 
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "terraform-state-hyorch-devopsaws"   
}

# Enable versioning so we can see the full revision history of our state files
resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = "terraform-state-hyorch-devopsaws"
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = "terraform-state-hyorch-devopsaws"  
  rule {
    apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
    }
  }
}