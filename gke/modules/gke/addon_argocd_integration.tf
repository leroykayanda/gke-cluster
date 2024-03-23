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
  name = "argocd"
}

resource "google_dns_record_set" "argo" {
  name         = "${var.argo_domain_name}."
  managed_zone = var.argo_zone_name
  type         = "A"
  ttl          = 300

  rrdatas = [google_compute_global_address.static-ip.address]
}

resource "google_compute_managed_ssl_certificate" "argo_cert" {
  name = "argocd"

  managed {
    domains = [var.argo_domain_name]
  }
}

resource "kubernetes_manifest" "argocd_frontendconfig" {
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
