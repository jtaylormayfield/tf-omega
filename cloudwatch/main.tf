resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.project_name}"

  dashboard_body = <<EOF
 {
   "widgets": [
       {
          "type":"metric",
          "x":0,
          "y":0,
          "width":12,
          "height":6,
          "properties":{
             "metrics":[
                [
                   "AWS/Billing",
                   "EstimatedCharges"
                ]
             ],
             "period":${6*60*60},
             "stat":"Maximum",
             "region":"${var.region_name}",
             "title":"Billing"
          }
       }
   ]
 }
 EOF
}

resource "aws_cloudwatch_metric_alarm" "billing" {
  alarm_name          = "billing"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "EstimatedCharges"
  namespace           = "AWS/Billing"
  period              = "${6*60*60}"
  statistic           = "Maximum"
  threshold           = "10"
  alarm_description   = "This alarm notifies the account holders of billing"
  alarm_actions       = ["${var.billing_sns_arn}"]
}
