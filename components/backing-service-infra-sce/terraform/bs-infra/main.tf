# main.tf

resource "aws_s3_bucket" "my_simple_bucket" {
  bucket = var.bucket_name
  # You can specify a region here if it differs from your AWS provider configuration
  # region = var.region

  tags = {
    Name  = var.bucket_name
    Owner = "sahoa" # The requested Owner tag
  }
}

# (Optional but Recommended) Block Public Access for security
resource "aws_s3_bucket_public_access_block" "my_simple_bucket_public_access_block" {
  bucket = aws_s3_bucket.my_simple_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# (Optional but Recommended) Enable Server-Side Encryption by default
resource "aws_s3_bucket_server_side_encryption_configuration" "my_simple_bucket_sse" {
  bucket = aws_s3_bucket.my_simple_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
