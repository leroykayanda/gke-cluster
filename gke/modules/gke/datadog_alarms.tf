#node cpu
resource "datadog_monitor" "node_cpu" {
  count   = var.create_monitor ? 1 : 0
  name    = "${var.cluster_name}-[Kubernetes]-High-Worker-Node-CPU"
  type    = "metric alert"
  message = local.cpu_monitor_message

  query = "avg(last_5m):avg:gcp.gke.node.cpu.allocatable_utilization{cluster_name:${var.cluster_name}} by {node_name} > ${var.cpu_threshold}"

  monitor_thresholds {
    critical = var.cpu_threshold
  }

  include_tags = false
  tags         = ["service:${var.monitor_service}"]
}

#node mem
resource "datadog_monitor" "node_mem" {
  count   = var.create_monitor ? 1 : 0
  name    = "${var.cluster_name}-[Kubernetes]-High-Worker-Node-Memory"
  type    = "metric alert"
  message = local.mem_monitor_message

  query = "avg(last_5m):avg:gcp.gke.node.memory.allocatable_utilization{cluster_name:${var.cluster_name}} by {node_name} > ${var.mem_threshold}"

  monitor_thresholds {
    critical = var.mem_threshold
  }

  include_tags = false
  tags         = ["service:${var.monitor_service}"]
}

#node disk 
resource "datadog_monitor" "node_disk" {
  count   = var.create_monitor ? 1 : 0
  name    = "${var.cluster_name}-[Kubernetes]-Low-Worker-Node-Storage"
  type    = "metric alert"
  message = local.disk_monitor_message

  query = "avg(last_5m):avg:gcp.gke.node.ephemeral_storage.used_bytes{cluster_name:${var.cluster_name}} by {node_name} > ${var.disk_threshold}"

  monitor_thresholds {
    critical = var.disk_threshold
  }

  include_tags = false
  tags         = ["service:${var.monitor_service}"]
}

#container cpu
resource "datadog_monitor" "container_cpu" {
  count   = var.create_monitor ? 1 : 0
  name    = "${var.cluster_name}-[Kubernetes]-High-Container-CPU-Usage"
  type    = "metric alert"
  message = local.container_cpu_monitor_message

  query = "avg(last_5m):avg:gcp.gke.container.cpu.limit_utilization{cluster_name:${var.cluster_name}} by {container_name} > ${var.container_cpu_threshold}"

  monitor_thresholds {
    critical = var.container_cpu_threshold
  }

  include_tags = false
  tags         = ["service:${var.monitor_service}"]
}

#container mem
resource "datadog_monitor" "container_mem" {
  count   = var.create_monitor ? 1 : 0
  name    = "${var.cluster_name}-[Kubernetes]-High-Container-Memory-Usage"
  type    = "metric alert"
  message = local.container_mem_monitor_message

  query = "avg(last_5m):avg:gcp.gke.container.memory.limit_utilization{cluster_name:${var.cluster_name}} by {container_name} > ${var.container_mem_threshold}"

  monitor_thresholds {
    critical = var.container_mem_threshold
  }

  include_tags = false
  tags         = ["service:${var.monitor_service}"]
}

#container restarts
resource "datadog_monitor" "container_restarts" {
  count   = var.create_monitor ? 1 : 0
  name    = "${var.cluster_name}-[Kubernetes]-Container-Restarting"
  type    = "metric alert"
  message = local.container_restart_monitor_message

  query = "sum(last_10m):sum:gcp.gke.container.restart_count.delta{cluster_name:${var.cluster_name}} by {container_name,pod_name,namespace_name} >= ${var.container_restart_threshold}"

  monitor_thresholds {
    critical = var.container_restart_threshold
  }

  include_tags = false
  tags         = ["service:${var.monitor_service}"]
}

#no running pods in a deployment
resource "datadog_monitor" "no_running_pods" {
  count   = var.create_monitor ? 1 : 0
  name    = "${var.cluster_name}-[Kubernetes]-No-Running-Pods"
  type    = "metric alert"
  message = local.deployment_has_no_running_pods

  query = "sum(last_5m):kubernetes_state.deployment.replicas_ready{kube_cluster_name:${var.cluster_name}} by {kube_deployment,kube_namespace} <= 0"

  monitor_thresholds {
    critical = 0
  }

  include_tags = false
  tags         = ["service:${var.monitor_service}"]
}
