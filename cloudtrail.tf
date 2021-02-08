######################################
#                                    #
#     CloudTrail configuration       #
#                                    #
######################################

locals {
  arn_parts    = split(":", aws_cloudwatch_log_group.cloudtrail.arn)
  wildcard_arn = join(":", concat(slice(local.arn_parts, 0, length(local.arn_parts) - 1)), ["*"])
}

# Setup CloudTrail
resource "aws_cloudtrail" "cloudtrail" {
  name                          = var.cloudtrail_name
  s3_bucket_name                = aws_s3_bucket.logging.bucket
  s3_key_prefix                 = var.cloudtrail_bucket_prefix
  include_global_service_events = var.cloudtrail_include_global_service_events
  is_multi_region_trail         = var.cloudtrail_multi_region
  enable_log_file_validation    = var.cloudtrail_enable_log_validation
  kms_key_id                    = aws_kms_key.cloudtrail.arn
  cloud_watch_logs_group_arn    = local.wildcard_arn
  cloud_watch_logs_role_arn     = aws_iam_role.cloudtrail.arn

  depends_on = [aws_s3_bucket_policy.logging]
}
