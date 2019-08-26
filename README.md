# <a name="top">GRACE Logging</a>[![CircleCI](https://circleci.com/gh/GSA/grace-logging.svg?style=svg&circle-token=3ba172998300c4ff769a83484c82c8305c8357e7)](https://circleci.com/gh/GSA/grace-logging)

## <a name="description">Description</a>
   The code provided within this subcomponent will create the AWS resources neccessary to configure and enable logging and log storage.  The subcomponent also provides a method for configuring a trust relationship with GSA/SecOps to allow for the retrieval and analysis of you [AWS CloudTrail](https://aws.amazon.com/cloudtrail/) log data using their ELK Stack. The GRACE Logging subcomponent activates AWS CLoudTrail and creates a multi-region CloudTrail Trail configured to deliver to both an [Amazon S3](https://aws.amazon.com/s3/) bucket and an [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/) Log Group. The required [AWS IAM](https://aws.amazon.com/iam/) resources are created to allow for the permissions required for CloudTrail's log delivery. The S3 bucket created for log storage is setup with a bucket policy, lifecycle policy, server-side encryption, versioning, and access logging. The GRACE logging subcomponent also creates a S3 bucket to store the access-log data generated from the CloudTrail log storage bucket.
   
   The GRACE Logging subcomponent will also provide the resources required to create a trust relationship with GSA SecOps.  This trust relationship will allow SecOps to pull the CloudTrail log data from the log storage bucket and analyze it using their Elasticsearch, Logstash, and Kibana (ELK) Stack.  The integration with SecOps utilizes [AWS Security Token Service (STS)](https://docs.aws.amazon.com/STS/latest/APIReference/Welcome.html) to allow the specified SecOps accounts access to assume a role specifically created for the consumption of the log data stored within the S3 log storage bucket. 
>NOTE: Customers can coordinate with SecOps to determine the appropriate AWS Account number(s) to configure for the trust policy. The account numbers specify which trusted account members are allowed to assume the role used for log integration with SecOps. 

## <a name="contents">Table of Contents</a>

- [Description](#description)
- [Diagram](#diagram)
- [Inputs](#inputs)
- [Outputs](#outputs)
- [Deployment Guide](#guide)
- [Security Compliance](#security)
- [Public Domain](#license)

## <a name="diagram">Diagram</a>
![grace-logging layout](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.github.com/GSA/grace-logging/grace-logging-documentation/res/diagram.uml)

[top](#top)

## <a name="input">Inputs</a>

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| access\_logging\_bucket\_acl | \(optional\) The ACL applied to the access logging bucket | string | `"log-delivery-write"` | no |
| access\_logging\_bucket\_backup\_days | \(optional\) The age of an object in number of days before it can be archived to glacier | string | `"365"` | no |
| access\_logging\_bucket\_backup\_expiration\_days | \(optional\) The age of an object in number of days before it can be safely discarded | string | `"900"` | no |
| access\_logging\_bucket\_block\_public\_acls | \(optional\) The boolean value enabling \(true\) or disabling \(false\) the blocking of public ACL creation for the access logging bucket | string | `"true"` | no |
| access\_logging\_bucket\_block\_public\_policy | \(optional\) The boolean value enabling \(true\) or disabling \(false\) the blocking of public policy creation for the access logging bucket | string | `"true"` | no |
| access\_logging\_bucket\_enable\_backup | \(optional\) The boolean value enabling \(true\) or disabling \(false\) backups to glacier on the access logging bucket | string | `"true"` | no |
| access\_logging\_bucket\_enable\_versioning | \(optional\) The boolean value enabling \(true\) or disabling \(false\) versioning on the access logging bucket | string | `"true"` | no |
| access\_logging\_bucket\_ignore\_public\_acls | \(optional\) The boolean value enabling \(true\) or disabling \(false\) the ignoring of public ACLs created for the access logging bucket | string | `"true"` | no |
| access\_logging\_bucket\_name | \(required\) The name given to the access logging bucket | string | n/a | yes |
| access\_logging\_bucket\_restrict\_public\_buckets | \(optional\) The boolean value enabling \(true\) or disabling \(false\) the blocking of public and cross-account access with the public bucket policy for the access logging bucket | string | `"true"` | no |
| cloudtrail\_bucket\_prefix | \(optional\) The prefix used when storing CloudTrail logs in the logging bucket | string | `"grace-cloudtrail"` | no |
| cloudtrail\_enable\_log\_validation | \(optional\) The boolean value indicating whether this CloudTrail should perform log file integrity validation | string | `"true"` | no |
| cloudtrail\_include\_global\_service\_events | \(optional\) The boolean value indicating whether global services are sending events to this CloudTrail \(ie: IAM\) | string | `"true"` | no |
| cloudtrail\_log\_retention\_days | \(optional\) The number of days to retain logs in the CloudWatch log group | string | `"365"` | no |
| cloudtrail\_multi\_region | \(optional\) The boolean value indicating whether this CloudTrail is multi-region | string | `"true"` | no |
| cloudtrail\_name | \(optional\) The name given to the CloudTrail | string | `"grace-cloudtrail"` | no |
| flowlogs\_bucket\_prefix | \(optional\) The prefix used when storing Flow logs in the logging bucket | string | `"grace-flowlogs"` | no |
| logging\_access\_logging\_prefix | \(optional\) The prefix used when storing access logs for the logging bucket | string | `"grace-logging"` | no |
| logging\_bucket\_acl | \(optional\) The ACL applied to the primary logging bucket | string | `"log-delivery-write"` | no |
| logging\_bucket\_backup\_days | \(optional\) The age of an object in number of days before it can be archived to glacier | string | `"365"` | no |
| logging\_bucket\_backup\_expiration\_days | \(optional\) The age of an object in number of days before it can be safely discarded | string | `"900"` | no |
| logging\_bucket\_block\_public\_acls | \(optional\) The boolean value enabling \(true\) or disabling \(false\) the blocking of public ACL creation for the logging bucket | string | `"true"` | no |
| logging\_bucket\_block\_public\_policy | \(optional\) The boolean value enabling \(true\) or disabling \(false\) the blocking of public policy creation for the logging bucket | string | `"true"` | no |
| logging\_bucket\_enable\_backup | \(optional\) The boolean value enabling \(true\) or disabling \(false\) backups to glacier on the logging bucket | string | `"true"` | no |
| logging\_bucket\_enable\_versioning | \(optional\) The boolean value enabling \(true\) or disabling \(false\) versioning on the logging bucket | string | `"true"` | no |
| logging\_bucket\_ignore\_public\_acls | \(optional\) The boolean value enabling \(true\) or disabling \(false\) the ignoring of public ACLs created for the logging bucket | string | `"true"` | no |
| logging\_bucket\_name | \(required\) The name given to the primary logging bucket | string | n/a | yes |
| logging\_bucket\_restrict\_public\_buckets | \(optional\) The boolean value enabling \(true\) or disabling \(false\) the blocking of public and cross-account access with the public bucket policy for the logging bucket | string | `"true"` | no |
| secops\_accounts | \(optional\) A comma delimited string containing the Account IDs of accounts that should access to your log buckets, if empty no external accounts will be allowed to read the logs | string | `""` | no |
| secops\_role\_name | \(optional\) The name given to the SecOps read only access to the logging bucket | string | `"grace-secops-read"` | no |

[top](#top)

## <a name="output">Outputs</a>

| Name | Description |
|------|-------------|
| access\_bucket\_arn | The ARN of the access log bucket. |
| access\_bucket\_id | The name of the access log bucket. |
| cloudtrail\_arn | The Amazon Resource Name of the trail. |
| cloudtrail\_id | The name of the trail. |
| cloudtrail\_kms\_key\_arn | The Amazon Resource Name \(ARN\) of the CloudTrail KMS key. |
| cloudtrail\_kms\_key\_id | The globally unique identifier for the CloudTrail KMS key. |
| cloudtrail\_log\_group\_arn | The Amazon Resource Name \(ARN\) specifying the CloudTrail log group |
| cloudtrail\_policy\_id | The ID of the CloudTrail policy. |
| cloudtrail\_role\_arn | The Amazon Resource Name \(ARN\) specifying the CloudTrail role. |
| cloudtrail\_role\_id | The name of the CloudTrail role. |
| logging\_bucket\_arn | The ARN of the logging bucket. |
| logging\_bucket\_id | The name of the logging bucket. |
| secops\_policy\_id | The ID of the secops read only policy. |
| secops\_role\_arn | The Amazon Resource Name \(ARN\) specifying the secops read only role. |
| secops\_role\_id | The name of the secops read only role. |

[top](#top)

## <a name="guide">Deployment Guide</a>

* Dependencies
    - Terraform (minimum version v0.10.4; recommend v0.12.6 or greater)
        - provider.aws ~v2.24.0
        - provider.template ~v2.1.2

* Usage

Include the module in your Terraform project.  See the above [inputs](#inputs) and [outputs](#outputs) for more details.  Basic example:

```
module "logging" {
  source                     = "github.com/GSA/grace-logging"
  access_logging_bucket_name = "example-access-logs"
  cloudtrail_name            = "example-trail"
  logging_bucket_name        = "example-logs"
}
```

Use `terraform init` to download and install module and providers

[top](#top)

## <a name="ops">Maintenance & Operations</a>

[top](#top)

## <a name="security">Security Compliance</a>
**Subcomponent approval status:** in assessment

### Security Control Coverage & SSP Narratives

**Relevant controls:**

Control | CSP/AWS | HOST/OS | App/DB | % Covered | How is it implemented?
---- | :---: | :---: | :---: | :---: | ---
[AU-2](https://nvd.nist.gov/800-53/Rev4/control/AU-2) | ╳ | | | | GRACE Logging deploys AWS CloudTrail for generation of Audit Events and provides a method of integration with GSA SecOps ELK Stack for additional analysis of log data.
[AU-3](https://nvd.nist.gov/800-53/Rev4/control/AU-3) | ╳ | | | | GRACE Logging deploys AWS CloudTrail for generation of Audit Events that establishes what type of event occurred, when the event occurred, where the event occurred, the source of the event, the outcome of the event, and the identity of any individuals or subjects associated with the event.
[AU-3(1)](https://nvd.nist.gov/800-53/Rev4/control/AU-3#enhancement-1) | ╳ | | | | 
[AU-4](https://nvd.nist.gov/800-53/Rev4/control/AU-4) | ╳ | | | | GRACE Logging utilizes Amazon S3 for the storage of Audit Events and Amazon Glacier for additional long term retention of log data.  These AWS storage services provide an unlimited capacity for log data retention.
[AU-6(1)](https://nvd.nist.gov/800-53/Rev4/control/AU-6#enhancement-1) | ╳ | | | | GRACE Logging provides an optional method for integration with GSA SecOps for continual review and analysis of log data by leveraging their ELK Stack.
[AU-7](https://nvd.nist.gov/800-53/Rev4/control/AU-7) | ╳ | | | | GRACE Logging configures AWS CloudTrail to deliver its log Trail to both a CLoudWatch Log Group and an S3 bucket.  The CloudWatch Log Group provides on-demand audit review, analysis, and reporting requirements in addition to the ability for conducting after-the-fact investigations of security incidents.  The log events stored within the S3 bucket are encrypted and retained for 365 days before being transfered to Amazon Glacier long term retention. The S3 log bucket is also enabled with S3 Server Access Logging to track all access requests to the bucket.
[AU-7(1)](https://nvd.nist.gov/800-53/Rev4/control/AU-7#enhancement-1) | ╳ | | | | 
[AU-8](https://nvd.nist.gov/800-53/Rev4/control/AU-8) | ╳ | | | | GRACE inherits time stamp generation from AWS in coordinated universal time (UTC).
[AU-8(1)](https://nvd.nist.gov/800-53/Rev4/control/AU-8#enhancement-1) | ╳ | | | | GRACE inherits time stamp generation from AWS in coordinated universal time (UTC).
[AU-12](https://nvd.nist.gov/800-53/Rev4/control/AU-12) | ╳ | | | | GRACE Logging  utilizes AWS CloudTrail to log and retain account activity related to actions within the AWS account infrastructure.


[top](#top)

## <a name="license">Public domain</a>

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.

[top](#top)
