output "endpoint" {
  value     = module.gke.endpoint
  sensitive = true
}

output "ca_certificate" {
  value     = base64decode(module.gke.ca_certificate)
  sensitive = true
}
