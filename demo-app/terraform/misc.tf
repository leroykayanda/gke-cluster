#artifact registry

resource "google_artifact_registry_repository" "my-repo" {
  location      = var.region
  repository_id = var.service
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }

  cleanup_policies {
    id     = "keep-minimum-versions"
    action = "KEEP"
    most_recent_versions {
      keep_count = 10
    }
  }
}

#ingress ip, ssl cert and dns record

resource "google_compute_global_address" "app_static_ip" {
  name = var.service
}

resource "google_compute_managed_ssl_certificate" "app_cert" {
  name = var.service

  managed {
    domains = [var.dns_name[var.env]]
  }
}

resource "google_dns_record_set" "app_domain" {
  name         = "${var.dns_name[var.env]}."
  managed_zone = var.zone_name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_address.app_static_ip.address]
}

# workload identity

resource "kubernetes_service_account" "ksa" {
  metadata {
    name      = var.service
    namespace = "${local.short_env}-${var.service}"
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.app_sa.email
    }
  }
}

resource "google_service_account" "app_sa" {
  account_id   = var.service
  display_name = var.service
}

resource "google_project_iam_member" "secretAccessor" {
  project = var.project_id[var.env]
  role    = "roles/secretmanager.secretAccessor"
  member  = "serviceAccount:${google_service_account.app_sa.email}"
}

resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.app_sa.name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.project_id[var.env]}.svc.id.goog[${local.short_env}-${var.service}/${var.service}]"]
}

# argo cd app

resource "argocd_application" "app" {
  metadata {
    name        = "${var.env}-${var.service}"
    namespace   = "argocd"
    annotations = var.argo_annotations[var.env]
    labels = {
      service = var.service
      env     = var.env
    }
  }

  spec {
    source {
      repo_url        = var.argo_repo
      target_revision = var.argo_target_revision[var.env]
      path            = var.argo_path[var.env]
    }
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "${local.short_env}-${var.service}"
    }
    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = false
      }
      sync_options = [
        "Validate=true",
        "CreateNamespace=false",
        "PrunePropagationPolicy=foreground"
      ]
    }

    ignore_difference {
      group         = "apps"
      kind          = "Deployment"
      json_pointers = ["/spec/replicas"]
    }
  }
}

