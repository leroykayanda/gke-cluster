terraform {
  backend "remote" {
    organization = "RentRahisi"

    workspaces {
      prefix = "gcp-networking-"
    }
  }

  required_providers {

    google = {
      source  = "hashicorp/google"
      version = "~> 5.21.0"
    }

  }
}
