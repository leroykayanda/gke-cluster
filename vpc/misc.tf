# resource "google_compute_project_default_network_tier" "default" {
#   network_tier = "PREMIUM"
# }

#NAT
resource "google_compute_router" "router" {
  name    = "router"
  region  = var.region
  network = module.vpc.network_id
}

resource "google_compute_address" "nat_ip" {
  name         = "nat-ip"
  region       = var.region
  address_type = "EXTERNAL"
  network_tier = var.network_tier[var.env]
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat"
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  nat_ips = [
    google_compute_address.nat_ip.self_link
  ]
  depends_on = [google_compute_address.nat_ip]
}
