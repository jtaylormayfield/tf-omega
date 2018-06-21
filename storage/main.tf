resource "random_id" "bucket_id" {
  byte_length = 4
}

resource "aws_s3_bucket" "bucket" {
  bucket        = "${var.project_name}-storage-${random_id.bucket_id.dec}"
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

  tags {
    Name = "${var.project_name}"
  }
}
