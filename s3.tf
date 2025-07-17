######################################
#                                    #
#       Logging configuration        #
#                                    #
######################################

# Create Bucket
resource "aws_s3_bucket" "logging" {
  bucket        = var.logging_bucket_name
  force_destroy = var.logging_bucket_destroy
}

# Configure bucket ACL
resource "aws_s3_bucket_acl" "logging" {
  bucket = aws_s3_bucket.logging.id
  acl    = var.logging_bucket_acl
  
  depends_on = [aws_s3_bucket_ownership_controls.logging]
}

# Configure bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure access logging
resource "aws_s3_bucket_logging" "logging" {
  bucket = aws_s3_bucket.logging.id

  target_bucket = aws_s3_bucket.access.id
  target_prefix = var.logging_access_logging_prefix
}

# Configure versioning
resource "aws_s3_bucket_versioning" "logging" {
  bucket = aws_s3_bucket.logging.id
  
  versioning_configuration {
    status = var.logging_bucket_enable_versioning ? "Enabled" : "Disabled"
  }
}

# Configure server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "logging" {
  bucket = aws_s3_bucket.logging.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.cloudtrail.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Configure lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "logging" {
  count  = var.logging_bucket_enable_backup ? 1 : 0
  bucket = aws_s3_bucket.logging.id

  rule {
    id     = "backup_and_cleanup"
    status = "Enabled"

    filter {
      prefix = var.logging_access_logging_prefix
    }

    transition {
      days          = var.logging_bucket_backup_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.logging_bucket_backup_expiration_days
    }
  }
}

# Set Public Access Block
resource "aws_s3_bucket_public_access_block" "logging" {
  bucket = aws_s3_bucket.logging.id

  block_public_acls       = var.logging_bucket_block_public_acls
  ignore_public_acls      = var.logging_bucket_ignore_public_acls
  block_public_policy     = var.logging_bucket_block_public_policy
  restrict_public_buckets = var.logging_bucket_restrict_public_buckets
}

# Create Bucket Policy
resource "aws_s3_bucket_policy" "logging" {
  bucket = aws_s3_bucket.logging.id
  policy = templatefile("${path.module}/files/bucket_policy.tpl.json", {
    bucket            = var.logging_bucket_name
    flowlog_folder    = var.flowlogs_bucket_prefix
    cloudtrail_folder = var.cloudtrail_bucket_prefix
  })

  depends_on = [aws_s3_bucket_public_access_block.logging]
}

######################################
#                                    #
# Access Logging configuration       #
#                                    #
######################################

# Create S3 Bucket
resource "aws_s3_bucket" "access" {
  #tfsec:ignore:AWS002
  bucket        = var.access_logging_bucket_name
  force_destroy = var.access_logging_bucket_destroy
}

# Configure bucket ACL
resource "aws_s3_bucket_acl" "access" {
  bucket = aws_s3_bucket.access.id
  acl    = var.access_logging_bucket_acl
  
  depends_on = [aws_s3_bucket_ownership_controls.access]
}

# Configure bucket ownership controls
resource "aws_s3_bucket_ownership_controls" "access" {
  bucket = aws_s3_bucket.access.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Configure versioning
resource "aws_s3_bucket_versioning" "access" {
  bucket = aws_s3_bucket.access.id
  
  versioning_configuration {
    status = var.access_logging_bucket_enable_versioning ? "Enabled" : "Disabled"
  }
}

# Configure lifecycle
resource "aws_s3_bucket_lifecycle_configuration" "access" {
  count  = var.access_logging_bucket_enable_backup ? 1 : 0
  bucket = aws_s3_bucket.access.id

  rule {
    id     = "backup_and_cleanup"
    status = "Enabled"

    filter {
      prefix = var.access_logging_bucket_name
    }

    transition {
      days          = var.access_logging_bucket_backup_days
      storage_class = "GLACIER"
    }

    expiration {
      days = var.access_logging_bucket_backup_expiration_days
    }
  }
}

# Configure server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "access" {
  bucket = aws_s3_bucket.access.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Set Public Access Block
resource "aws_s3_bucket_public_access_block" "access" {
  bucket = aws_s3_bucket.access.id

  block_public_acls       = var.access_logging_bucket_block_public_acls
  ignore_public_acls      = var.access_logging_bucket_ignore_public_acls
  block_public_policy     = var.access_logging_bucket_block_public_policy
  restrict_public_buckets = var.access_logging_bucket_restrict_public_buckets
}
