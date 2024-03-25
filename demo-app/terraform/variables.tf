variable "region" {
  type    = string
  default = "europe-west1"
}

variable "env" {
  type = string
}

variable "short_env" {
  default = {
    development = "dev"
    production  = "prod"
  }
}

variable "project_id" {
  default = {
    development = "tumahela"
    production  = ""
  }
}

variable "service" {
  type    = string
  default = "demo-app"
}

variable "dns_name" {
  default = {
    development = "demo-app.gcp.rentrahisi.co.ke"
    production  = ""
  }
}

variable "zone_name" {
  type    = string
  default = "rentrahisi"
}

#argocd
variable "argo_annotations" {
  type = map(map(string))
  default = {
    "development" = {
      "notifications.argoproj.io/subscribe.on-health-degraded.slack" = "rentrahisi"
      "argocd-image-updater.argoproj.io/image-list"                  = "repo=europe-west1-docker.pkg.dev/tumahela/demo-app/demo-app"
      "argocd-image-updater.argoproj.io/repo.update-strategy"        = "latest"
      "argocd-image-updater.argoproj.io/myimage.ignore-tags"         = "latest"
    },
    "prod" = {
    }
  }
}

variable "argo_repo" {
  type    = string
  default = "git@github.com:leroykayanda/gke-cluster.git"
}

variable "argo_target_revision" {
  type = map(string)
  default = {
    "development" = "main"
    "production"  = ""
  }
}

variable "argo_path" {
  type = map(string)
  default = {
    "development" = "demo-app/manifests/overlays/dev"
    "production"  = ""
  }
}

variable "argo_server" {
  type = map(string)
  default = {
    "development" = "dev-argo.gcp.rentrahisi.co.ke:443"
    "production"  = ""
  }
}
