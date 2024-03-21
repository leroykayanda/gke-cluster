#service account
resource "google_service_account" "datadog" {
  account_id   = "datadog"
  display_name = "datadog"
}

resource "google_project_iam_member" "monitoring_viewer" {
  project = var.project_id
  role    = "roles/monitoring.viewer"
  member  = "serviceAccount:${google_service_account.datadog.email}"
}

resource "google_project_iam_member" "compute_viewer" {
  project = var.project_id
  role    = "roles/compute.viewer"
  member  = "serviceAccount:${google_service_account.datadog.email}"
}

resource "google_project_iam_member" "cloud_asset_viewer" {
  project = var.project_id
  role    = "roles/cloudasset.viewer"
  member  = "serviceAccount:${google_service_account.datadog.email}"
}

resource "google_project_iam_member" "browser" {
  project = var.project_id
  role    = "roles/browser"
  member  = "serviceAccount:${google_service_account.datadog.email}"
}

#datadog<>gcp integration
resource "google_service_account_iam_member" "sa_iam" {
  service_account_id = google_service_account.datadog.name
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = format("serviceAccount:%s", datadog_integration_gcp_sts.integration.delegate_account_email)
}

resource "datadog_integration_gcp_sts" "integration" {
  client_email    = google_service_account.datadog.email
  is_cspm_enabled = false
  automute        = true
}

#datadog helm chart
resource "helm_release" "datadog_agent" {
  count      = var.cluster_created ? 1 : 0
  name       = "datadog-agent"
  repository = "https://helm.datadoghq.com"
  chart      = "datadog"
  namespace  = "kube-system"

  set {
    name  = "datadog.apiKey"
    value = var.DATADOG_API_KEY
  }

  set {
    name  = "datadog.appKey"
    value = var.DATADOG_APP_KEY
  }

  set {
    name  = "datadog.site"
    value = var.DATADOG_SITE
  }

  set {
    name  = "datadog.logs.enabled"
    value = true
  }

  set {
    name  = "datadog.logs.containerCollectAll"
    value = true
  }

  set {
    name  = "datadog.containerIncludeLogs"
    value = var.namespaces_to_log
  }

  set {
    name  = "datadog.containerExcludeLogs"
    value = "kube_namespace:.*"
  }
}
