######################################
#                                    #
#       SecOps configuration         #
#                                    #
######################################

# Generate assume_role_policy from secops_accounts variable
data "aws_iam_policy_document" "secops" {
  count = "${length(var.secops_accounts) > 0 ? 1 : 0}"
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = "${formatlist("arn:aws:iam::%s:root", split(",", "${var.secops_accounts}"))}"
    }
  }
}

# Create IAM Role with assume_role_policy
resource "aws_iam_role" "secops" {
  count              = "${length(var.secops_accounts) > 0 ? 1 : 0}"
  name               = "${var.secops_role_name}"
  assume_role_policy = "${aws_iam_policy_document.secops}"
}

# Create IAM policy
resource "aws_iam_role_policy" "secops" {
  count = "${length(var.secops_accounts) > 0 ? 1 : 0}"
  name  = "${var.secops_role_name}"
  role  = "${aws_iam_role.secops.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetBucketLocation",
                "s3:ListAllMyBuckets"
            ],
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${aws_s3_bucket.logging.bucket}",
                "arn:aws:s3:::${aws_s3_bucket.logging.bucket}/*"
            ]
        }
    ]
}
EOF
}
