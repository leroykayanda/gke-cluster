provider "google" {
  project = var.project_id[var.env]
  region  = var.region
}

provider "kubernetes" {
  host                   = "https://${data.terraform_remote_state.gke.outputs.gke_endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = data.terraform_remote_state.gke.outputs.gke_ca_certificate
}

provider "argocd" {
  server_addr = var.argo_server[var.env]
}
