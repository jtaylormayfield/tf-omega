resource "aws_sns_topic" "billing" {
  name = "billing-topic"
}

resource "aws_sns_topic" "autoscale" {
  name = "autoscale-topic"
}

resource "aws_sns_topic_subscription" "billing" {
  topic_arn = "${aws_sns_topic.billing.arn}"
  protocol  = "lambda"
  endpoint  = "${var.billing_lambda}"
}

resource "aws_sns_topic_subscription" "autoscale" {
  topic_arn = "${aws_sns_topic.autoscale.arn}"
  protocol  = "lambda"
  endpoint  = "${var.autoscale_lambda}"
}
