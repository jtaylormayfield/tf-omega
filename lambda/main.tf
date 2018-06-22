resource "aws_iam_role" "email_lambda" {
  name = "email_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "email" {
  name = "/aws/lambda/email"
}

data "aws_s3_bucket_object" "email_lambda" {
  bucket = "${var.email_bucket}"
  key    = "${var.email_path}"
}

resource "aws_lambda_function" "email" {
  s3_bucket         = "${var.email_bucket}"
  s3_key            = "${var.email_path}"
  s3_object_version = "${data.aws_s3_bucket_object.email_lambda.version_id}"
  function_name     = "email"
  role              = "${aws_iam_role.email_lambda.arn}"
  runtime           = "${var.email_runtime}"
  handler           = "${var.email_handler}"

  environment {
    variables = {
      USERNAME  = "${var.email_username}"
      PASSWORD  = "${var.email_password}"
      SMTPHOST  = "${var.email_smtp_host}"
      SMTPPORT  = "${var.email_smtp_port}"
      MAIL_FROM = "${var.email_from}"
      MAIL_TO   = "${var.email_to}"
    }
  }
}
