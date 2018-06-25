output "billing_arn" {
  value = "${aws_sns_topic.billing.arn}"
}

output "autoscale_arn" {
  value = "${aws_sns_topic.autoscale.arn}"
}
