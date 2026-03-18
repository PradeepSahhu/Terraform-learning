provider "aws" {
  region = "us-east-1" # Change if needed
}

# -----------------------------
# S3 Bucket
# -----------------------------
resource "aws_s3_bucket" "my_bucket" {
  bucket = "pradeep-bucket-name-32123" # MUST be globally unique

  tags = {
    Name        = "MyVersionedBucket"
    Environment = "Dev"
  }
}


# -----------------------------
# Versioning
# -----------------------------
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.my_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# -----------------------------
# Block Public Access
# -----------------------------
resource "aws_s3_bucket_public_access_block" "block_public" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# -----------------------------
# Server-Side Encryption
# -----------------------------
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# -----------------------------
# Lifecycle Rule (Optional)
# Deletes old versions after 30 days
# -----------------------------
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.my_bucket.id

  rule {
    id     = "cleanup-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}