#https://medium.com/google-cloud/automated-sync-among-gcp-secrets-gke-workload-4797913576f2

resource "helm_release" "secrets" {
  count      = var.cluster_created ? 1 : 0
  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  namespace  = "kube-system"
}

resource "helm_release" "reloader" {
  count      = var.cluster_created ? 1 : 0
  name       = "reloader"
  repository = "https://stakater.github.io/stakater-charts"
  chart      = "reloader"
  namespace  = "kube-system"

  set {
    name  = "reloader.reloadStrategy"
    value = "annotations"
  }
}
