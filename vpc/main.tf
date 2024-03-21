module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 9.0"

  project_id              = var.project_id[var.env]
  network_name            = var.vpc_name[var.env]
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false

  subnets = [
    {
      subnet_name           = "subnet-01"
      subnet_ip             = var.subnet_cidr[var.env]
      subnet_region         = var.region
      subnet_private_access = true
      subnet_flow_logs      = false
    }
  ]

  secondary_ranges = {
    subnet-01 = [
      {
        range_name    = "kubernetes-pods"
        ip_cidr_range = var.pods_cidr[var.env]
      },
      {
        range_name    = "kubernetes-services"
        ip_cidr_range = var.services_cidr[var.env]
      }
    ]
  }

}
