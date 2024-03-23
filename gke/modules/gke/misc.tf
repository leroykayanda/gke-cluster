#enable APIs
resource "google_project_service" "api" {
  count                      = length(var.required_apis)
  project                    = var.project_id
  service                    = element(var.required_apis, count.index)
  disable_dependent_services = false
  disable_on_destroy         = false
}

#GKE service account
resource "google_service_account" "gke" {
  account_id   = "gke-sa"
  display_name = "gke-sa"
}

resource "google_project_iam_member" "artifactregistry" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "node_monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "monitoring_metricWriter" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "logWriter" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "stackdriver" {
  project = var.project_id
  role    = "roles/stackdriver.resourceMetadata.writer"
  member  = "serviceAccount:${google_service_account.gke.email}"
}

resource "google_project_iam_member" "autoscaling_metricsWriter" {
  project = var.project_id
  role    = "roles/autoscaling.metricsWriter"
  member  = "serviceAccount:${google_service_account.gke.email}"
}
