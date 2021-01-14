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