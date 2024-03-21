resource "google_compute_firewall" "ssh" {
  name    = "ssh"
  network = module.vpc.network_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  direction     = "INGRESS"
}
