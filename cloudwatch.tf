# Create Log Group
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = var.cloudtrail_name
  retention_in_days = var.cloudtrail_log_retention_days
}