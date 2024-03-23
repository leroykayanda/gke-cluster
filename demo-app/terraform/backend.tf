terraform {

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "RentRahisi"

    workspaces {
      prefix = "demo-app-gcp-"
    }
  }

  required_providers {

    google = {
      source  = "hashicorp/google"
      version = "~> 5.21.0"
    }

    argocd = {
      source  = "oboukili/argocd"
      version = "6.0.3"
    }

  }
}
