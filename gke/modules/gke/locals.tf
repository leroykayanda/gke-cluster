locals {
  cpu_monitor_message = "{{#is_alert}}${var.alert_channels} Worker Node {{node_name.name}} in kubernetes cluster ${var.cluster_name} is experiencing high CPU usage.  {{/is_alert}} {{#is_recovery}}${var.alert_channels} Worker Node {{node_name.name}} in kubernetes cluster ${var.cluster_name} CPU Usage is back to normal! {{/is_recovery}}"

  mem_monitor_message = "{{#is_alert}}${var.alert_channels} Worker Node {{node_name.name}} in kubernetes cluster ${var.cluster_name} is experiencing high Memory usage.  {{/is_alert}} {{#is_recovery}}${var.alert_channels} Worker Node {{node_name.name}} in kubernetes cluster ${var.cluster_name} Memory Usage is back to normal! {{/is_recovery}}"

  disk_monitor_message = "{{#is_alert}}${var.alert_channels} Worker Node {{node_name.name}} in kubernetes cluster ${var.cluster_name} is experiencing low storage.  {{/is_alert}} {{#is_recovery}}${var.alert_channels} Worker Node {{node_name.name}} in kubernetes cluster ${var.cluster_name} storage is back to normal! {{/is_recovery}}"

  container_cpu_monitor_message = "{{#is_alert}}${var.alert_channels} The container {{container_name.name}} in kubernetes cluster ${var.cluster_name} is experiencing high CPU usage. {{/is_alert}} {{#is_recovery}}${var.alert_channels} The container {{container_name.name}} in kubernetes cluster ${var.cluster_name} CPU is back to normal! {{/is_recovery}}"

  container_mem_monitor_message = "{{#is_alert}}${var.alert_channels} The container {{container_name.name}} in kubernetes cluster ${var.cluster_name} is experiencing high Memory usage. {{/is_alert}} {{#is_recovery}}${var.alert_channels} The container {{container_name.name}} in kubernetes cluster ${var.cluster_name} Memory is back to normal! {{/is_recovery}}"

  container_restart_monitor_message = "{{#is_alert}}${var.alert_channels} The Container: {{container_name.name}} in Pod: {{pod_name.name}} in Namespace: {{namespace_name.name}} in kubernetes cluster ${var.cluster_name} is restarting. {{/is_alert}} {{#is_recovery}}${var.alert_channels} The container {{container_name.name}} in kubernetes cluster ${var.cluster_name} is no longer restarting! {{/is_recovery}}"

  deployment_has_no_running_pods = "{{#is_alert}}${var.alert_channels} The deployment {{kube_deployment.name}} in the namespace {{kube_namespace.name}} in the  kubernetes cluster ${var.cluster_name} has no running pods. {{/is_alert}} {{#is_recovery}}@slack-RentRahisi-rentrahisi The deployment {{kube_deployment.name}} in the namespace {{kube_namespace.name}} in the  kubernetes cluster ${var.cluster_name} now has running pods! {{/is_recovery}}"
}
