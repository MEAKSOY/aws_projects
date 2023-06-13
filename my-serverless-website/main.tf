provider "aws" {
    region = "us-east-1"
    default_tags {
      tags = {
        project = "my-serverless-demo"
        type = "web"
        iac = "terraform"
      }
    }  
}

resource "aws_s3_bucket" "website_bucket" {
  bucket = "esat-bucket-june13"
}

resource "aws_s3_object" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  key = "index.html"
  source = "index.html"
  content_type = "text/html"
}

resource "aws_s3_account_public_access_block" "website_bucket" {
  block_public_acls = false
  block_public_policy = false
}

resource "aws_s3_bucket_public_access_block" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsondecode({
    Version = "2023-06-13"
    Statement = [
      {
        Sid = "PublicReadGetObject"
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
        ]
        Resource = [
          "${aws_s3_bucket.website_bucket.arn}",
          "${aws_s3_bucket.website_bucket.arn}/*"
        ]
      }
    ]
  })
}