terraform {

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "RentRahisi"

    workspaces {
      prefix = "gke-"
    }
  }

  required_providers {

    google = {
      source  = "hashicorp/google"
      version = "~> 5.21.0"
    }

    datadog = {
      source  = "DataDog/datadog"
      version = "3.36.0"
    }

  }
}
