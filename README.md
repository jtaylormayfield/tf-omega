# tf-omega
Linux Academy Lab - AWS Essentials - Omega Terraform

Notes

* The AWS provider does not support email SNS, so I setup a little Python lambda to do email notifications.
* I already had a domain structure in Cloudflare I wanted to use, so I forsook Route53 for that exercise.
* Much refactoring could be done. More variables could be exposed in tfvars
* All data stored in any of this infra should be considered ephemeral and backed up manually if persistent storage is required.
