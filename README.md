# tf-omega
Linux Academy Lab - AWS Essentials - Omega Terraform

## Use Case
Linux Academy offers a plethora of courses designed to help people get into cloud automation. Between the [Terraform course](https://linuxacademy.com/cp/modules/view/id/175) and the [AWS Concepts course](https://linuxacademy.com/cp/modules/view/id/84) I gained an appreciation for how incredibly easy it is to setup simple infrastructures in AWS using Terraform. As I entered the [AWS Essentials course](https://linuxacademy.com/cp/modules/view/id/91), it struck me during the first few lessons that it would be a good challenge for me to take what I learned about Terraform and use it to create the proposed architecture in the Essentials course. This repository contains the code that resulted from my attempt to avoid using the AWS UI during the entire course. The reference architecture is [here](http://bit.ly/2guw5gY).

I tried to stay as close to the architecture as possible using my own free-tier account. I changed things up a bit around the Cloudwatch, Lambda, and Route 53 lessons for various reasons. I don't think you can use the creds for the LA sandbox lab to run this plan because IAM is locked down. The advantage of the Terraform execution plan is that if you are beyond free tier, you can decomm everything at the end of the day and stay within a very reasonable price range.

## IMPORTANT DATA NOTICE
All data stored in any of this infra should be considered ephemeral and backed up manually if persistent storage is required. The execution plan was designed to leave nothing behind in the AWS console. Consequently, if you need to keep ELB access logs stored in the log bucket or data you created on the RDS instance, you'll need to back it up yourself. You've been warned. Stay stateless.

## Variable Example
I provided an example .tfvars file to expose all of the variables necessary to build out the entire infra. More variables could definitely be exposed to make the plan a little more abstract from the LA course requirements.

## SNS & Lambda Fun
I had some issues with the SMTP SNS subscription, so I used a third-party SMTP service to get the alerts to work. I use Lambda subscriptions on both the billing and autoscale topics to trigger emails from a little Python script I found and modified. This allowed me to kill two academic birds with one stone, so to speak. Digging into the Lambda resources from the AWS TF provider was really important for me from the developer perspective because it allowed me to envision what a continuous delivery chain might look like for a serverless application architecture. It does require an S3 bucket backend and some extra work though. I stepped through a slightly modified version of the process documented [here](http://blog.rambabusaravanan.com/send-smtp-email-using-aws-lambda/) to accomplish the task.

## DNS
Route 53 is great and easy to use but I already had a domain architecture in Cloudflare so I chose to introduce myself to a new provider. The Cloudflare TF provider is probably super disappointing for people who use CF heavily but since I only needed to get DNS records in place (and DNS is literally the only thing supported by the CF provider right now) I was a happy camper.
