output "cloudtrail_id" {
  description = "The name of the trail."
  value       = aws_cloudtrail.cloudtrail.id
}

output "cloudtrail_arn" {
  description = "The Amazon Resource Name of the trail."
  value       = aws_cloudtrail.cloudtrail.arn
}

output "cloudtrail_log_group_arn" {
  description = "The Amazon Resource Name (ARN) specifying the CloudTrail log group"
  value       = aws_cloudwatch_log_group.cloudtrail.arn
}

output "cloudtrail_log_group_name" {
  description = "The name of the CloudTrail log group"
  value       = aws_cloudwatch_log_group.cloudtrail.name
}

output "cloudtrail_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the CloudTrail role."
  value       = aws_iam_role.cloudtrail.arn
}

output "cloudtrail_role_id" {
  description = "The name of the CloudTrail role."
  value       = aws_iam_role.cloudtrail.id
}

output "cloudtrail_policy_id" {
  description = "The ID of the CloudTrail policy."
  value       = aws_iam_role_policy.cloudtrail.id
}

output "cloudtrail_kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the CloudTrail KMS key."
  value       = aws_kms_key.cloudtrail.arn
}

output "cloudtrail_kms_key_id" {
  description = "The globally unique identifier for the CloudTrail KMS key."
  value       = aws_kms_key.cloudtrail.key_id
}

output "logging_bucket_arn" {
  description = "The ARN of the logging bucket."
  value       = aws_s3_bucket.logging.arn
}

output "logging_bucket_id" {
  description = "The name of the logging bucket."
  value       = aws_s3_bucket.logging.id
}

output "access_bucket_id" {
  description = "The name of the access log bucket."
  value       = aws_s3_bucket.access.id
}

output "access_bucket_arn" {
  description = "The ARN of the access log bucket."
  value       = aws_s3_bucket.access.arn
}

output "secops_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the secops read only role."
  value = [
    for role in aws_iam_role.secops :
    role.arn
  ]
}

output "secops_role_id" {
  description = "The name of the secops read only role."
  value = [
    for role in aws_iam_role.secops :
    role.id
  ]
}

output "secops_policy_id" {
  description = "The ID of the secops read only policy."
  value = [
    for policy in aws_iam_role_policy.secops :
    policy.id
  ]
}
