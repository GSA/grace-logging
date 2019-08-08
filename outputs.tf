output "cloudtrail_id" {
  value = "${aws_cloudtrail.cloudtrail.id}"
}
output "cloudtrail_arn" {
  value = "${aws_cloudtrail.cloudtrail.arn}"
}

output "cloudtrail_log_group_arn" {
  value = "${aws_cloudwatch_log_group.cloudtrail.arn}"
}

output "cloudtrail_role_arn" {
  value = "${aws_iam_role.cloudtrail.arn}"
}

output "cloudtrail_role_id" {
  value = "${aws_iam_role.cloudtrail.id}"
}
output "cloudtrail_policy_id" {
  value = "${aws_iam_role_policy.cloudtrail.id}"
}

output "cloudtrail_kms_key_arn" {
  value = "${aws_kms_key.cloudtrail.arn}"
}
output "cloudtrail_kms_key_id" {
  value = "${aws_kms_key.cloudtrail.key_id}"
}


output "logging_bucket_arn" {
  value = "${aws_s3_bucket.logging.arn}"
}

output "access_bucket_id" {
  value = "${aws_s3_bucket.access.id}"
}
output "access_bucket_arn" {
  value = "${aws_s3_bucket.access.arn}"
}

output "logging_bucket_id" {
  value = "${aws_s3_bucket.logging.id}"
}


output "secops_role_arn" {
  value = "${aws_iam_role.secops.0.arn}"
}

output "secops_role_id" {
  value = "${aws_iam_role.secops.0.id}"
}
output "secops_policy_id" {
  value = "${aws_iam_role_policy.secops.0.id}"
}
