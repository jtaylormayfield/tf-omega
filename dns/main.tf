resource "cloudflare_record" "main-cname" {
  domain = "${var.domain}"
  name   = "${var.name}"
  value  = "${var.default_lb_name}"
  type   = "CNAME"
  ttl    = 3600
}
