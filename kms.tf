# Create KMS Key
resource "aws_kms_key" "cloudtrail" {
  description         = "A KMS key to encrypt CloudTrail events."
  enable_key_rotation = "true"

  policy = length(var.secops_accounts) > 0 ? templatefile("${path.module}/files/cloudtrail_key_policy.tpl.json", {
    account_id  = data.aws_caller_identity.current.account_id
    region      = data.aws_region.current.name
    secops_role = var.secops_role_name
  }) : templatefile("${path.module}/files/cloudtrail_key_policy_no_secops.tpl.json", {
    account_id = data.aws_caller_identity.current.account_id
    region     = data.aws_region.current.name
  })
}
