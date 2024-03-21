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

resource "google_project_iam_member" "editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.gke.email}"
}
