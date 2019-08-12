######################################
#                                    #
#       Logging configuration        #
#                                    #
######################################

# Create Bucket
resource "aws_s3_bucket" "logging" {
  bucket = "${var.logging_bucket_name}"
  acl    = "${var.logging_bucket_acl}"

  logging {
    target_bucket = "${aws_s3_bucket.access.id}"
    target_prefix = "${var.logging_access_logging_prefix}"
  }

  versioning {
    enabled = "${var.logging_bucket_enable_versioning}"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "${aws_kms_key.cloudtrail.arn}"
        sse_algorithm     = "aws:kms"
      }
    }
  }

  lifecycle_rule {
    enabled = "${var.logging_bucket_enable_backup}"

    prefix = "${var.logging_access_logging_prefix}"

    transition {
      days          = "${var.logging_bucket_backup_days}"
      storage_class = "GLACIER"
    }

    expiration {
      days = "${var.logging_bucket_backup_expiration_days}"
    }
  }
}

# Set Public Access Block
resource "aws_s3_bucket_public_access_block" "logging" {
  bucket = "${aws_s3_bucket.logging.id}"

  block_public_acls       = "${var.logging_bucket_block_public_acls}"
  ignore_public_acls      = "${var.logging_bucket_ignore_public_acls}"
  block_public_policy     = "${var.logging_bucket_block_public_policy}"
  restrict_public_buckets = "${var.logging_bucket_restrict_public_buckets}"
}

data "template_file" "bucket_policy" {
  template = "${file("${path.module}/files/bucket_policy.tpl.json")}"
  vars = {
    bucket            = "${var.logging_bucket_name}"
    flowlog_folder    = "${var.flowlogs_bucket_prefix}"
    cloudtrail_folder = "${var.cloudtrail_bucket_prefix}"
  }
}

# Create Bucket Policy
resource "aws_s3_bucket_policy" "logging" {
  bucket = "${aws_s3_bucket.logging.id}"
  policy = "${data.template_file.bucket_policy.rendered}"
}

######################################
#                                    #
# Access Logging configuration       #
#                                    #
######################################

# Create S3 Bucket
resource "aws_s3_bucket" "access" {
  bucket = "${var.access_logging_bucket_name}"
  acl    = "${var.access_logging_bucket_acl}"

  versioning {
    enabled = "${var.access_logging_bucket_enable_versioning}"
  }

  lifecycle_rule {
    enabled = "${var.access_logging_bucket_enable_backup}"

    prefix = "${var.access_logging_bucket_name}"

    transition {
      days          = "${var.access_logging_bucket_backup_days}"
      storage_class = "GLACIER"
    }

    expiration {
      days = "${var.access_logging_bucket_backup_expiration_days}"
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Set Public Access Block
resource "aws_s3_bucket_public_access_block" "access" {
  bucket = "${aws_s3_bucket.access.id}"

  block_public_acls       = "${var.access_logging_bucket_block_public_acls}"
  ignore_public_acls      = "${var.access_logging_bucket_ignore_public_acls}"
  block_public_policy     = "${var.access_logging_bucket_block_public_policy}"
  restrict_public_buckets = "${var.access_logging_bucket_restrict_public_buckets}"
}
