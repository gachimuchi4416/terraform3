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