module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  project_id                 = var.project_id
  name                       = var.cluster_name
  region                     = var.region
  network                    = var.network_name
  subnetwork                 = var.subnetwork
  ip_range_pods              = var.ip_range["pods"]
  ip_range_services          = var.ip_range["services"]
  http_load_balancing        = true
  horizontal_pod_autoscaling = true
  release_channel            = var.release_channel
  remove_default_node_pool   = true
  maintenance_start_time     = var.maintenance_start_time
  maintenance_end_time       = var.maintenance_end_time
  maintenance_recurrence     = var.maintenance_recurrence
  enable_private_nodes       = true
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  create_service_account     = false
  deletion_protection        = false

  node_pools = [
    {
      name               = "gke-node-pool"
      machine_type       = var.machine_type
      initial_node_count = var.initial_node_count
      total_min_count    = var.min_count
      total_max_count    = var.max_count
      disk_size_gb       = var.disk_size_gb
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      enable_gcfs        = true
      enable_gvnic       = true
      auto_upgrade       = var.auto_upgrade
      service_account    = google_service_account.gke.email
      node_locations     = var.node_locations
      auto_repair        = false
    },
  ]

  node_pools_tags = {
    all = ["worker-node"]

    gke-node-pool = [
      "gke-node-pool",
    ]
  }
}
