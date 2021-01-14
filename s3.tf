#パブリックS3バケット
resource "aws_s3_bucket" "public_bucket" {
  bucket = "yui-yasuhiko-public-bucket"
  acl    = "public-read"
  #テスト用なので、今回は削除可能
  force_destroy = true
  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    # expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

#プライベートS3バケット
resource "aws_s3_bucket" "private_bucket" {
  bucket = "yui-yasuhiko-private-bucket"
  acl    = "private"
  #テスト用なので、今回は削除可能
  force_destroy = true
  tags = {
    Name = "yui-yasuhiko-private-bucket"
  }
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

#ALBログ用バケット
resource "aws_s3_bucket" "alb_access_log" {
  bucket = "yui-yasuhiko-alb-logs-bucket"
  acl    = "private"
  #テスト用なので、今回は削除可能
  force_destroy = true
  tags = {
    Name = "yui-yasuhiko-alb-logs-bucket"
  }
  lifecycle_rule {
    enabled = true
    id      = "alb-access-log-web"
    expiration {
      days = 1
    }
  }
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::582318560864:root"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::yui-yasuhiko-alb-logs-bucket/*"
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::yui-yasuhiko-alb-logs-bucket/*",
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    },
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "delivery.logs.amazonaws.com"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::yui-yasuhiko-alb-logs-bucket"
    }
  ]
}
POLICY
}
