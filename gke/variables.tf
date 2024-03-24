variable "region" {
  type    = string
  default = "europe-west1"
}

variable "env" {
  type = string
}

variable "project_id" {
  default = {
    development = "tumahela"
    production  = ""
  }
}

variable "network_name" {
  default = {
    development = "development"
    production  = ""
  }
}

variable "subnetwork" {
  type    = string
  default = "subnet-01"
}

#kubernetes
variable "cluster_name" {
  default = {
    development = "development"
    production  = ""
  }
}

variable "node_locations" {
  default = {
    development = "europe-west1-b"
    production  = "europe-west1-b,europe-west1-c"
  }
}

variable "ip_range" {
  default = {
    pods     = "kubernetes-pods"
    services = "kubernetes-services"
  }
}

variable "machine_type" {
  default = {
    development = "e2-standard-4"
    production  = ""
  }
}

variable "release_channel" {
  default = {
    development = "REGULAR"
    production  = "STABLE"
  }
}

variable "initial_node_count" {
  default = {
    development = 1
    production  = 1
  }
}

variable "min_count" {
  default = {
    development = 1
    production  = 2
  }
}

variable "max_count" {
  default = {
    development = 2
    production  = 5
  }
}

variable "auto_upgrade" {
  default = {
    development = true
    production  = false
  }
}

variable "maintenance_start_time" {
  description = "Start time of the maintenance window"
  type        = string
  default     = "2024-01-28T23:00:00Z"
}

variable "maintenance_end_time" {
  description = "End time of the maintenance window"
  type        = string
  default     = "2024-01-29T03:00:00Z"
}

variable "maintenance_recurrence" {
  description = "Recurrence pattern for the maintenance window"
  type        = string
  default     = "FREQ=WEEKLY;BYDAY=FR,SA,SU"
}

variable "master_ipv4_cidr_block" {
  type    = string
  default = "192.168.1.0/28"
}

#datadog
variable "cluster_created" {
  default = {
    development = true
    production  = false
  }
}

variable "DATADOG_API_KEY" {
}

variable "DATADOG_APP_KEY" {
}

variable "DD_APP_URL" {
  default = "https://api.datadoghq.eu/"
}

variable "DATADOG_SITE" {
  default = "datadoghq.eu"
}

variable "alert_channels" {
  default = {
    development = "@slack-RentRahisi-rentrahisi"
    production  = ""
  }
}

variable "create_monitor" {
  default = {
    development = true
    production  = true
  }
}

variable "namespaces_to_log" {
  type        = string
  description = "List of namespaces we want to send logs to datadog for"
  default     = "kube_namespace:dev-demo-app"
}

#argocd
variable "argo_domain_name" {
  type = map(string)
  default = {
    development = "dev-argo.gcp.rentrahisi.co.ke"
    production  = ""
  }
}

variable "argo_zone_name" {
  type = map(string)
  default = {
    development = "rentrahisi"
    production  = ""
  }
}

variable "argo_ssh_private_key" {
  description = "The SSH private key"
  type        = string
}

variable "argo_repo" {
  type    = string
  default = "git@github.com:leroykayanda"
}

variable "argo_slack_token" {
  type = string
}

variable "argocd_image_updater_values" {
  type = list(string)
  default = [
    <<EOF
config:
  registries:
    - name: GCP Artifact Registry
      api_url: https://europe-west1-docker.pkg.dev
      prefix: europe-west1-docker.pkg.dev
      credentials: ext:/auth/auth.sh
      credsexpire: 30m
volumes:
- configMap:
    defaultMode: 0755
    name: auth-cm
  name: auth
volumeMounts:
- mountPath: /auth
  name: auth
EOF
  ]
}
