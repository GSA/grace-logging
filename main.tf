data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
  bucket_name = var.bucket_name != "" ? var.bucket_name : "grace-logging-${random_id.bucket_suffix.hex}"
  
  # Create a normalized policy document to avoid formatting differences
  bucket_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowLoggingAccess"
        Effect = "Allow"
        Principal = {
          Service = "logging.amazonaws.com"
        }
        Action = [
          "s3:PutObject",
          "s3:GetBucketAcl"
        ]
        Resource = [
          "arn:aws:s3:::${local.bucket_name}",
          "arn:aws:s3:::${local.bucket_name}/*"
        ]
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "random_id" "bucket_suffix" {
  byte_length = 8
}

# S3 bucket with proper lifecycle management
resource "aws_s3_bucket" "logging_bucket" {
  bucket        = local.bucket_name
  force_destroy = var.force_destroy

  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      tags["CreatedDate"]
    ]
  }

  tags = merge(var.tags, {
    Name        = local.bucket_name
    Purpose     = "Grace Logging"
    CreatedDate = timestamp()
  })
}

# Separate bucket policy resource with proper dependencies
resource "aws_s3_bucket_policy" "logging_policy" {
  bucket = aws_s3_bucket.logging_bucket.id
  policy = local.bucket_policy

  depends_on = [
    aws_s3_bucket.logging_bucket,
    aws_s3_bucket_public_access_block.logging_bucket
  ]

  lifecycle {
    ignore_changes = [
      # Ignore policy formatting differences
    ]
  }
}

# Public access block to prevent conflicts
resource "aws_s3_bucket_public_access_block" "logging_bucket" {
  bucket = aws_s3_bucket.logging_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  depends_on = [aws_s3_bucket.logging_bucket]
}

# Versioning configuration
resource "aws_s3_bucket_versioning" "logging_bucket" {
  bucket = aws_s3_bucket.logging_bucket.id
  
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }

  depends_on = [aws_s3_bucket.logging_bucket]
}

# Lifecycle configuration for log retention
resource "aws_s3_bucket_lifecycle_configuration" "logging_bucket" {
  count  = var.log_retention_days > 0 ? 1 : 0
  bucket = aws_s3_bucket.logging_bucket.id

  rule {
    id     = "log_retention"
    status = "Enabled"

    expiration {
      days = var.log_retention_days
    }

    noncurrent_version_expiration {
      noncurrent_days = var.log_retention_days
    }
  }

  depends_on = [aws_s3_bucket_versioning.logging_bucket]
}

# Server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "logging_bucket" {
  bucket = aws_s3_bucket.logging_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }

  depends_on = [aws_s3_bucket.logging_bucket]
}
