provider "aws" {
    region = "us-east-1"  
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "esat-bucket-june13"
}