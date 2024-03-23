data "google_client_config" "default" {}

data "terraform_remote_state" "gke" {
  backend = "remote"

  config = {
    organization = "RentRahisi"
    workspaces = {
      name = "gke-${var.env}"
    }
  }
}
