data "template_file" "cloudtrail_key_policy" {
  template = file("${path.module}/files/cloudtrail_key_policy.tpl.json")
  vars = {
    account_id  = data.aws_caller_identity.current.account_id
    region      = data.aws_region.current.name
    secops_role = var.secops_role_name
  }
}

# Create KMS Key
resource "aws_kms_key" "cloudtrail" {
  description         = "A KMS key to encrypt CloudTrail events."
  enable_key_rotation = "true"

  policy = data.template_file.cloudtrail_key_policy.rendered

  depends_on = [
    aws_iam_role.secops
  ]
}
