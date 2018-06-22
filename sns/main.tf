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

resource "aws_lambda_permission" "billing" {
  statement_id  = "AllowExecutionFromBillingSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${var.billing_lambda}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.billing.arn}"
}

resource "aws_lambda_permission" "autoscale" {
  statement_id  = "AllowExecutionFromAutoscaleSNS"
  action        = "lambda:InvokeFunction"
  function_name = "${var.autoscale_lambda}"
  principal     = "sns.amazonaws.com"
  source_arn    = "${aws_sns_topic.autoscale.arn}"
}
