resource "random_id" "bucket_id" {
  byte_length = 4
}

data "aws_elb_service_account" "main" {}

locals {
  bucket_name = "${var.project_name}-storage-${random_id.bucket_id.dec}"
}

resource "aws_s3_bucket" "bucket" {
  bucket        = "${local.bucket_name}"
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id      = "archive"
    enabled = true

    transition {
      days          = 90
      storage_class = "GLACIER"
    }
  }

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::${local.bucket_name}/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY

  tags {
    Name = "${var.project_name}"
  }
}
