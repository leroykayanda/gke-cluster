variable "project_id" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "network_name" {
  type = string
}

variable "subnetwork" {
  type = string
}

variable "ip_range" {
  type = map(string)
}

variable "release_channel" {
  type = string
}

variable "maintenance_start_time" {
  description = "Start time of the maintenance window"
  type        = string
}

variable "maintenance_end_time" {
  description = "End time of the maintenance window"
  type        = string
}

variable "maintenance_recurrence" {
  description = "Recurrence pattern for the maintenance window"
  type        = string
}

variable "master_ipv4_cidr_block" {
  type = string
}

variable "machine_type" {
  type = string
}

variable "initial_node_count" {
  type = number
}

variable "min_count" {
  type = number
}

variable "max_count" {
  type = number
}

variable "disk_size_gb" {
  type    = number
  default = 200
}

variable "auto_upgrade" {
  type = string
}

variable "required_apis" {
  default = [
    "cloudbilling.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "monitoring.googleapis.com",
    "compute.googleapis.com",
    "cloudasset.googleapis.com",
    "iam.googleapis.com",
    "container.googleapis.com",
    "artifactregistry.googleapis.com",
    "logging.googleapis.com",
    "certificatemanager.googleapis.com",
    "secretmanager.googleapis.com"
  ]
}

variable "node_locations" {
  type = string
}

#datadog
variable "alert_channels" {
  type = string
}

variable "cluster_created" {
}

variable "DATADOG_API_KEY" {
}

variable "DATADOG_APP_KEY" {
}

variable "DATADOG_SITE" {
  default = "datadoghq.eu"
}

variable "create_monitor" {
}

variable "cpu_threshold" {
  type    = number
  default = 0.9
}

variable "mem_threshold" {
  type    = number
  default = 0.9
}

variable "disk_threshold" {
  type    = number
  default = 190000000000
}

variable "container_cpu_threshold" {
  type    = number
  default = 0.9
}

variable "container_mem_threshold" {
  type    = number
  default = 0.9
}

variable "container_restart_threshold" {
  type    = number
  default = 2
}

variable "monitor_service" {
  default = "kubernetes"
}

variable "namespaces_to_log" {
  type        = string
  description = "List of namespaces we want to send logs to datadog for"
}

#argocd
variable "argo_domain_name" {
  type = string
}

variable "argo_zone_name" {
  type = string
}

variable "argo_repo" {
  type = string
}

variable "argo_ssh_private_key" {
  description = "The SSH private key"
  type        = string
}

variable "argo_slack_token" {
  type = string
}

variable "argocd_image_updater_values" {
}
