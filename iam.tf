######################################
#                                    #
#     SecOps IAM configuration       #
#                                    #
######################################

# Generate assume_role_policy from secops_accounts variable
data "aws_iam_policy_document" "secops" {
  count = length(var.secops_accounts) > 0 ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = formatlist("arn:aws:iam::%s:root", split(",", var.secops_accounts))
    }
  }
}

# Create IAM Role with assume_role_policy
resource "aws_iam_role" "secops" {
  count              = length(var.secops_accounts) > 0 ? 1 : 0
  name               = var.secops_role_name
  assume_role_policy = data.aws_iam_policy_document.secops[0].json
}

# Create IAM policy
resource "aws_iam_role_policy" "secops" {
  count = length(var.secops_accounts) > 0 ? 1 : 0
  name  = var.secops_role_name
  role  = aws_iam_role.secops[0].id

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

######################################
#                                    #
#   CloudTrail IAM configuration     #
#                                    #
######################################

# Create IAM Role
resource "aws_iam_role" "cloudtrail" {
  name = var.cloudtrail_name

  assume_role_policy = <<END_OF_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
END_OF_POLICY

}

# Create IAM Policy for Role
resource "aws_iam_role_policy" "cloudtrail" {
  name = var.cloudtrail_name

  role = aws_iam_role.cloudtrail.id

  policy = <<END_OF_POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AWSCloudTrailCreateLogStream2014110",
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream"
      ],
      "Resource": [
        "arn:aws:logs:${local.region}:${local.account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail.name}:log-stream:*"
      ]
    },
    {
      "Sid": "AWSCloudTrailPutLogEvents20141101",
      "Effect": "Allow",
      "Action": [
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${local.region}:${local.account_id}:log-group:${aws_cloudwatch_log_group.cloudtrail.name}:log-stream:*"
      ]
    }
  ]
}
END_OF_POLICY

}