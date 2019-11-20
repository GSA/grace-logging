variable "access_logging_bucket_name" {
  type        = string
  description = "(required) The name given to the access logging bucket"
}

variable "access_logging_bucket_acl" {
  description = "(optional) The ACL applied to the access logging bucket"
  default     = "log-delivery-write"
}

variable "access_logging_bucket_enable_versioning" {
  description = "(optional) The boolean value enabling (true) or disabling (false) versioning on the access logging bucket"
  default     = "true"
}

variable "access_logging_bucket_enable_backup" {
  description = "(optional) The boolean value enabling (true) or disabling (false) backups to glacier on the access logging bucket"
  default     = "true"
}

variable "access_logging_bucket_backup_days" {
  description = "(optional) The age of an object in number of days before it can be archived to glacier"
  default     = "365"
}

variable "access_logging_bucket_backup_expiration_days" {
  description = "(optional) The age of an object in number of days before it can be safely discarded"
  default     = "900"
}

variable "access_logging_bucket_block_public_acls" {
  description = "(optional) The boolean value enabling (true) or disabling (false) the blocking of public ACL creation for the access logging bucket"
  default     = "true"
}

variable "access_logging_bucket_ignore_public_acls" {
  description = "(optional) The boolean value enabling (true) or disabling (false) the ignoring of public ACLs created for the access logging bucket"
  default     = "true"
}

variable "access_logging_bucket_block_public_policy" {
  description = "(optional) The boolean value enabling (true) or disabling (false) the blocking of public policy creation for the access logging bucket"
  default     = "true"
}

variable "access_logging_bucket_restrict_public_buckets" {
  description = "(optional) The boolean value enabling (true) or disabling (false) the blocking of public and cross-account access with the public bucket policy for the access logging bucket"
  default     = "true"
}

variable "cloudtrail_name" {
  description = "(optional) The name given to the CloudTrail"
  default     = "grace-cloudtrail"
}

variable "cloudtrail_bucket_prefix" {
  description = "(optional) The prefix used when storing CloudTrail logs in the logging bucket"
  default     = "grace-cloudtrail"
}

variable "flowlogs_bucket_prefix" {
  description = "(optional) The prefix used when storing Flow logs in the logging bucket"
  default     = "grace-flowlogs"
}

variable "cloudtrail_include_global_service_events" {
  description = "(optional) The boolean value indicating whether global services are sending events to this CloudTrail (ie: IAM)"
  default     = "true"
}

variable "cloudtrail_multi_region" {
  description = "(optional) The boolean value indicating whether this CloudTrail is multi-region"
  default     = "true"
}

variable "cloudtrail_enable_log_validation" {
  description = "(optional) The boolean value indicating whether this CloudTrail should perform log file integrity validation"
  default     = "true"
}

variable "cloudtrail_log_retention_days" {
  description = "(optional) The number of days to retain logs in the CloudWatch log group"
  default     = "365"
}

variable "logging_bucket_name" {
  type        = string
  description = "(required) The name given to the primary logging bucket"
}

variable "logging_access_logging_prefix" {
  description = "(optional) The prefix used when storing access logs for the logging bucket"
  default     = "grace-logging"
}

variable "logging_bucket_acl" {
  description = "(optional) The ACL applied to the primary logging bucket"
  default     = "log-delivery-write"
}

variable "logging_bucket_enable_versioning" {
  description = "(optional) The boolean value enabling (true) or disabling (false) versioning on the logging bucket"
  default     = "true"
}

variable "logging_bucket_enable_backup" {
  description = "(optional) The boolean value enabling (true) or disabling (false) backups to glacier on the logging bucket"
  default     = "true"
}

variable "logging_bucket_backup_days" {
  description = "(optional) The age of an object in number of days before it can be archived to glacier"
  default     = "365"
}

variable "logging_bucket_backup_expiration_days" {
  description = "(optional) The age of an object in number of days before it can be safely discarded"
  default     = "900"
}

variable "logging_bucket_block_public_acls" {
  description = "(optional) The boolean value enabling (true) or disabling (false) the blocking of public ACL creation for the logging bucket"
  default     = "true"
}

variable "logging_bucket_ignore_public_acls" {
  description = "(optional) The boolean value enabling (true) or disabling (false) the ignoring of public ACLs created for the logging bucket"
  default     = "true"
}

variable "logging_bucket_block_public_policy" {
  description = "(optional) The boolean value enabling (true) or disabling (false) the blocking of public policy creation for the logging bucket"
  default     = "true"
}

variable "logging_bucket_restrict_public_buckets" {
  description = "(optional) The boolean value enabling (true) or disabling (false) the blocking of public and cross-account access with the public bucket policy for the logging bucket"
  default     = "true"
}

variable "secops_accounts" {
  description = "(optional) A comma delimited string containing the Account IDs of accounts that should access to your log buckets, if empty no external accounts will be allowed to read the logs"
  default     = ""
}

variable "secops_role_name" {
  description = "(optional) The name given to the SecOps read only access to the logging bucket"
  default     = "grace-secops-read"
}

