# GRACE Logging

## Description
The code provided within this subcomponent will create the AWS resources neccessary to configure and enable logging and log storage.  The subcomponent also provides a method for configuring a trust relationship with GSA/SecOps to allow for the retrieval and analysis of you CloudTrail log data using their ELK Stack. The GRACE Logging subcomponent relies on the use of the following AWS services and resources:

* [AWS IAM](https://aws.amazon.com/iam/)
* [Amazon S3](https://aws.amazon.com/s3/)
* [AWS CloudTrail](https://aws.amazon.com/cloudtrail/)
* [Amazon CloudWatch](https://aws.amazon.com/cloudwatch/)

## Diagram
![grace-logging layout](http://www.plantuml.com/plantuml/proxy?cache=no&src=https://raw.github.com/GSA/grace-logging/grace-logging-documentation/res/diagram.uml)

## Parameters
|      Parameters      	|  Type  	| Required 	|     Default Value     	|                  Description                  |
|:--------------------	|:------:	|:--------:	|:---------------------:	|:---------------------------------------------	|
| parameter_A           | string 	|    yes   	|        word       	    | The word used for X            	              |
| parameter_B           | num 	  |    yes   	|        123       	      | The numerical value used for Y                |

## Deployment Guide

* Dependencies

* Installation

* Usage

## Maintenance & Operations


## Security Compliance
**Subcomponent approval status:** in assessment



### Security Control Coverage & SSP Naratives

**Relevant controls:**

Control | CSP/AWS | HOST/OS | App/DB | How is it implemented?
--- | :---: | :---: | :---: | ---
[AC-2(a)](https://nvd.nist.gov/800-53/Rev4/control/AC-2) | ╳ | | | AWS accounts are created for tenants of the platform as member accounts in the AWS Organization.

## Repository contents


## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
