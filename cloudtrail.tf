######################################
#                                    #
#     CloudTrail configuration       #
#                                    #
######################################

# Setup CloudTrail
resource "aws_cloudtrail" "cloudtrail" {
  name                          = "${var.cloudtrail_name}"
  s3_bucket_name                = "${aws_s3_bucket.logging.bucket}"
  s3_key_prefix                 = "${var.cloudtrail_bucket_prefix}"
  include_global_service_events = "${var.cloudtrail_include_global_service_events}"
  is_multi_region_trail         = "${var.cloudtrail_multi_region}"
  enable_log_file_validation    = "${var.cloudtrail_enable_log_validation}"
  kms_key_id                    = "${aws_kms_key.cloudtrail.key_id}"
  cloud_watch_logs_group_arn    = "${aws_cloudwatch_log_group.cloudtrail.arn}"
  cloud_watch_logs_role_arn     = "${aws_iam_role.cloudtrail.arn}"
}

# Create Log Group
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "${var.cloudtrail_name}"
  retention_in_days = "${var.cloudtrail_log_retention_days}"
}

# Create IAM Role
resource "aws_iam_role" "cloudtrail" {
  name = "${var.cloudtrail_name}"

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
  name = "${var.cloudtrail_name}"

  role = "${aws_iam_role.cloudtrail.id}"

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


# Create KMS Key
resource "aws_kms_key" "cloudtrail" {
  description         = "A KMS key to encrypt CloudTrail events."
  enable_key_rotation = "true"

  policy = <<END_OF_POLICY
{
    "Version": "2012-10-17",
    "Id": "Key policy created by CloudTrail",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
              "AWS": "arn:aws:iam::${local.account_id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow CloudTrail to encrypt logs",
            "Effect": "Allow",
            "Principal": {"Service": ["cloudtrail.amazonaws.com"]},
            "Action": "kms:GenerateDataKey*",
            "Resource": "*",
            "Condition": {
              "StringLike": {
                "kms:EncryptionContext:aws:cloudtrail:arn":[
       	 	      "arn:aws:cloudtrail:*:${local.account_id}:trail/*",
      			  ]}
            }
        },
        {
            "Sid": "Allow CloudTrail to describe key",
            "Effect": "Allow",
            "Principal": {"Service": ["cloudtrail.amazonaws.com"]},
            "Action": "kms:DescribeKey",
            "Resource": "*"
        },
        {
            "Sid": "Allow principals in the account to decrypt log files",
            "Effect": "Allow",
            "Principal": {"AWS": "*"},
            "Action": [
                "kms:Decrypt",
                "kms:ReEncryptFrom"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {"kms:CallerAccount": "${local.account_id}"},
                "StringLike": {"kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${local.account_id}:trail/*"}
            }
        },
        {
            "Sid": "Allow alias creation during setup",
            "Effect": "Allow",
            "Principal": {"AWS": "*"},
            "Action": "kms:CreateAlias",
            "Resource": "*",
            "Condition": {"StringEquals": {
                "kms:ViaService": "ec2.${local.region}.amazonaws.com",
                "kms:CallerAccount": "${local.account_id}"
            }}
        },
        {
            "Sid": "Enable cross account log decryption",
            "Effect": "Allow",
            "Principal": {"AWS": "*"},
            "Action": [
                "kms:Decrypt",
                "kms:ReEncryptFrom"
            ],
            "Resource": "*",
            "Condition": {
                "StringEquals": {"kms:CallerAccount": "${local.account_id}"},
                "StringLike": {"kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${local.account_id}:trail/*"}
            }
        }
    ]
}
END_OF_POLICY
}
