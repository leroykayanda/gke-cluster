resource "kubernetes_namespace" "ns" {
  count = var.cluster_created ? 1 : 0
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  count      = var.cluster_created ? 1 : 0
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  namespace  = "argocd"
  version    = "6.7.3"

  set {
    name  = "server.service.type"
    value = "NodePort"
  }

  set {
    name  = "notifications.secret.create"
    value = false
  }

  set {
    name  = "notifications.cm.create"
    value = false
  }

  set {
    name  = "notifications.containerPorts.metrics"
    value = 9002
  }

  values = [
    <<EOT
configs:
  cm:
    "timeout.reconciliation": "60s"
  params:
    "server.insecure": true
EOT
  ]
}

resource "google_compute_global_address" "static-ip" {
  count = var.cluster_created ? 1 : 0
  name  = "argocd"
}

resource "google_dns_record_set" "argo" {
  count        = var.cluster_created ? 1 : 0
  name         = "${var.argo_domain_name}."
  managed_zone = var.argo_zone_name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_address.static-ip[0].address]
}

resource "google_compute_managed_ssl_certificate" "argo_cert" {
  count = var.cluster_created ? 1 : 0
  name  = "argocd"

  managed {
    domains = [var.argo_domain_name]
  }
}

resource "kubernetes_manifest" "argocd_frontendconfig" {
  count = var.cluster_created ? 1 : 0
  manifest = {
    "apiVersion" = "networking.gke.io/v1beta1"
    "kind"       = "FrontendConfig"
    "metadata" = {
      "name"      = "argocd"
      "namespace" = "argocd"
    }
    "spec" = {
      "redirectToHttps" = {
        "enabled" = true
      }
    }
  }
}

#kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode
resource "kubernetes_manifest" "argocd_ingress" {
  count = var.cluster_created ? 1 : 0
  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      annotations = {
        "ingress.gcp.kubernetes.io/pre-shared-cert"   = "argocd"
        "kubernetes.io/ingress.class"                 = "gce"
        "kubernetes.io/ingress.global-static-ip-name" = "argocd"
        "networking.gke.io/v1beta1.FrontendConfig"    = "argocd"
      }
      name      = "argocd"
      namespace = "argocd"
    }
    spec = {
      rules = [
        {
          host = var.argo_domain_name
          http = {
            paths = [
              {
                backend = {
                  service = {
                    name = "argo-cd-argocd-server"
                    port = {
                      number = 80
                    }
                  }
                }
                path     = "/"
                pathType = "Prefix"
              }
            ]
          }
        }
      ]

    }
  }
}

#argo ssh auth

resource "kubernetes_secret" "argo-secret" {
  count = var.cluster_created ? 1 : 0
  metadata {
    name      = "private-repo"
    namespace = "argocd"
    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }

  type = "Opaque"

  data = {
    "type"          = "git"
    "url"           = var.argo_repo
    "sshPrivateKey" = var.argo_ssh_private_key
  }
}

#argo notifications secret

resource "kubernetes_secret" "argocd_notifications_secret" {
  count = var.cluster_created ? 1 : 0
  metadata {
    name      = "argocd-notifications-secret"
    namespace = "argocd"
  }

  data = {
    "slack-token" = var.argo_slack_token
  }

  type = "Opaque"
}

#argo notifications

resource "kubernetes_config_map" "argocd_notifications_cm" {
  count = var.cluster_created ? 1 : 0
  metadata {
    name      = "argocd-notifications-cm"
    namespace = "argocd"
  }

  data = {
    "service.slack" = <<-EOT
      token: $slack-token
    EOT

    "context" = <<-EOT
      argocdUrl: https://${var.argo_domain_name}
    EOT

    "trigger.on-health-degraded" = <<-EOT
      - when: app.status.health.status == 'Degraded' || app.status.health.status == 'Missing' || app.status.health.status == 'Unknown'
        send: [app-degraded]
    EOT

    "template.app-degraded" = <<-EOT
      message: |
        ArgoCD - Application {{.app.metadata.name}} is {{.app.status.health.status}}.
      slack:
        attachments: |
          [{
            "title": "{{.app.metadata.name}}",
            "title_link": "{{.context.argocdUrl}}/applications/argocd/{{.app.metadata.name}}",
            "color": "#ff0000",
            "fields": [{
              "title": "App Health",
              "value": "{{.app.status.health.status}}",
              "short": true
            }, {
              "title": "Repository",
              "value": "{{.app.spec.source.repoURL}}",
              "short": true
            }]
          }]
    EOT
  }
}

# image updater

resource "helm_release" "image_updater" {
  count      = var.cluster_created ? 1 : 0
  name       = "argocd-image-updater"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"
  namespace  = "argocd"
  version    = "0.9.6"
  values     = var.argocd_image_updater_values

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = "argocd-image-updater-sa"
  }

}

# workload identity for image updater
# https://github.com/argoproj-labs/argocd-image-updater/issues/319

resource "kubernetes_service_account" "ksa" {
  count = var.cluster_created ? 1 : 0
  metadata {
    name      = "argocd-image-updater-sa"
    namespace = "argocd"
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.app_sa[0].email
    }
  }
}

resource "google_service_account" "app_sa" {
  count        = var.cluster_created ? 1 : 0
  account_id   = "argocd-image-updater-sa"
  display_name = "argocd-image-updater-sa"
}

resource "google_project_iam_member" "artifactregistry_repoAdmin" {
  count   = var.cluster_created ? 1 : 0
  project = var.project_id
  role    = "roles/artifactregistry.repoAdmin"
  member  = "serviceAccount:${google_service_account.app_sa[0].email}"
}

resource "google_service_account_iam_binding" "argo_workload_identity_binding" {
  count              = var.cluster_created ? 1 : 0
  service_account_id = google_service_account.app_sa[0].name
  role               = "roles/iam.workloadIdentityUser"
  members            = ["serviceAccount:${var.project_id}.svc.id.goog[argocd/argocd-image-updater-sa]"]
}

resource "kubernetes_config_map" "auth_cm" {
  count = var.cluster_created ? 1 : 0
  metadata {
    name      = "auth-cm"
    namespace = "argocd"
  }

  data = {
    "auth.sh" = <<EOF
#!/bin/sh
ACCESS_TOKEN=$(wget --header 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token -q -O - | grep -Eo '"access_token":.*?[^\\]",' | cut -d '"' -f 4)
echo "oauth2accesstoken:$ACCESS_TOKEN"
EOF
  }
}
