output "fqdn" {
  value = "${cloudflare_record.main-cname.hostname}"
}
