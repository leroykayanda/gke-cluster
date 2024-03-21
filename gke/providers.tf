provider "google" {
  project = var.project_id[var.env]
  region  = var.region
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = module.gke.ca_certificate
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    cluster_ca_certificate = module.gke.ca_certificate
    token                  = data.google_client_config.default.access_token
  }
}

provider "datadog" {
  api_key = var.DATADOG_API_KEY
  app_key = var.DATADOG_APP_KEY
  api_url = "https://api.datadoghq.eu/"
}
