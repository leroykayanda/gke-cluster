provider "google" {
  project = var.project_id[var.env]
  region  = var.region
}
