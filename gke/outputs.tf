output "gke_endpoint" {
  value     = module.gke.endpoint
  sensitive = true
}

output "gke_ca_certificate" {
  value     = module.gke.ca_certificate
  sensitive = true
}
