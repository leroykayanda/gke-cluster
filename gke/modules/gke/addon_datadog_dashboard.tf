
resource "datadog_dashboard_json" "k8s_dashboard" {
  dashboard = <<EOF
{
  "title": "${var.cluster_name}",
  "description": "${var.cluster_name}",
  "widgets": [
    {
      "id": 5001624786717028,
      "definition": {
        "title": "NODES",
        "background_color": "yellow",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 3741395108181267,
            "definition": {
              "title": "Node CPU Usage",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "vertical",
              "legend_columns": [
                "value"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "alias": "% CPU",
                      "number_format": {
                        "unit": {
                          "type": "canonical_unit",
                          "unit_name": "fraction"
                        }
                      },
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:gcp.gke.node.cpu.allocatable_utilization{cluster_name:${var.cluster_name}} by {node_name}",
                      "data_source": "metrics",
                      "name": "query1"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "green",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "label": "",
                "min": "auto",
                "max": "auto"
              },
              "markers": [
                {
                  "label": "  usage = 90%  ",
                  "value": "y = 0.9",
                  "display_type": "error dashed"
                }
              ]
            },
            "layout": {
              "x": 0,
              "y": 0,
              "width": 4,
              "height": 4
            }
          },
          {
            "id": 5615846121730394,
            "definition": {
              "title": "Node Memory Usage",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "vertical",
              "legend_columns": [
                "value"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "number_format": {
                        "unit": {
                          "type": "canonical_unit",
                          "unit_name": "fraction"
                        }
                      },
                      "alias": "% Mem",
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:gcp.gke.node.memory.allocatable_utilization{cluster_name:${var.cluster_name}} by {node_name}",
                      "data_source": "metrics",
                      "name": "query1"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "green",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "label": "",
                "min": "auto",
                "max": "auto"
              },
              "markers": [
                {
                  "label": "  usage = 90%  ",
                  "value": "y = 0.9",
                  "display_type": "error dashed"
                }
              ]
            },
            "layout": {
              "x": 4,
              "y": 0,
              "width": 4,
              "height": 4
            }
          },
          {
            "id": 4326336498675594,
            "definition": {
              "title": "Node Ephemeral Storage Usage",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "vertical",
              "legend_columns": [
                "value"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "style": {
                        "palette": "green"
                      },
                      "alias": "Storage Used",
                      "formula": "query2"
                    }
                  ],
                  "queries": [
                    {
                      "query": "avg:gcp.gke.node.ephemeral_storage.used_bytes{cluster_name:${var.cluster_name}} by {node_name}",
                      "data_source": "metrics",
                      "name": "query2"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "red",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "label": "",
                "min": "auto",
                "max": "auto"
              },
              "markers": [
                {
                  "label": " usage = 200Gb ",
                  "value": "y = 200000000000",
                  "display_type": "error bold"
                }
              ]
            },
            "layout": {
              "x": 8,
              "y": 0,
              "width": 4,
              "height": 4
            }
          },
          {
            "id": 700808065160688,
            "definition": {
              "title": "Nodes",
              "title_size": "16",
              "title_align": "left",
              "time": {
                "live_span": "1m"
              },
              "type": "query_value",
              "requests": [
                {
                  "response_format": "scalar",
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "max:kubernetes_state.node.count{kube_cluster_name:${var.cluster_name}}",
                      "aggregator": "max"
                    }
                  ],
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ]
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 0,
              "y": 4,
              "width": 2,
              "height": 2
            }
          },
          {
            "id": 8434628728998710,
            "definition": {
              "title": "Node Scaling",
              "title_size": "16",
              "title_align": "left",
              "show_legend": false,
              "legend_layout": "vertical",
              "legend_columns": [
                "avg",
                "min",
                "max",
                "value",
                "sum"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "avg:kubernetes_state.node.count{kube_cluster_name:${var.cluster_name}}"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ]
            },
            "layout": {
              "x": 2,
              "y": 4,
              "width": 5,
              "height": 3
            }
          },
          {
            "id": 2063426578268244,
            "definition": {
              "title": "Nodes by condition",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "vertical",
              "legend_columns": [
                "value"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1",
                      "alias": "no"
                    }
                  ],
                  "queries": [
                    {
                      "query": "min:kubernetes_state.node.by_condition{kube_cluster_name:${var.cluster_name} ,status:true} by {condition}",
                      "data_source": "metrics",
                      "name": "query1"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "cool",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "label": "",
                "min": "auto",
                "max": "auto"
              },
              "markers": []
            },
            "layout": {
              "x": 7,
              "y": 4,
              "width": 5,
              "height": 3
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 0,
        "width": 12,
        "height": 8
      }
    },
    {
      "id": 6826614475166118,
      "definition": {
        "title": "PODS",
        "background_color": "blue",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 2277141592273240,
            "definition": {
              "title": "Num of Pods",
              "title_size": "16",
              "title_align": "left",
              "type": "query_value",
              "requests": [
                {
                  "formulas": [
                    {
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "sum:kubernetes.pods.running{cluster-name:${var.cluster_name}}",
                      "aggregator": "min"
                    }
                  ],
                  "response_format": "scalar"
                }
              ],
              "autoscale": true,
              "precision": 2
            },
            "layout": {
              "x": 0,
              "y": 0,
              "width": 2,
              "height": 2
            }
          },
          {
            "id": 7137867327701770,
            "definition": {
              "title": "Pods per Node",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "vertical",
              "legend_columns": [
                "value"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "alias": "pods",
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "sum:kubernetes.pods.running{cluster-name:${var.cluster_name}} by {kube_node}"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ]
            },
            "layout": {
              "x": 2,
              "y": 0,
              "width": 5,
              "height": 4
            }
          },
          {
            "id": 3251791585271422,
            "definition": {
              "title": "Pods per Namespace",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "vertical",
              "legend_columns": [
                "value"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "alias": "pods",
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "sum:kubernetes.pods.running{cluster_name:${var.cluster_name}} by {kube_namespace}"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ]
            },
            "layout": {
              "x": 7,
              "y": 0,
              "width": 5,
              "height": 4
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 8,
        "width": 12,
        "height": 5
      }
    },
    {
      "id": 2997563958071846,
      "definition": {
        "title": "CONTAINERS",
        "background_color": "green",
        "show_title": true,
        "type": "group",
        "layout_type": "ordered",
        "widgets": [
          {
            "id": 2252436394559772,
            "definition": {
              "title": "Container CPU usage (%)",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "vertical",
              "legend_columns": [
                "avg"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "alias": "CPU Usage",
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "query": "sum:gcp.gke.container.cpu.limit_utilization{cluster_name:${var.cluster_name}} by {container_name}",
                      "data_source": "metrics",
                      "name": "query1"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "warm",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "label": "",
                "min": "auto",
                "max": "auto"
              },
              "markers": [
                {
                  "label": " usage = 90% ",
                  "value": "y = 0.9",
                  "display_type": "error dashed"
                }
              ]
            },
            "layout": {
              "x": 0,
              "y": 0,
              "width": 4,
              "height": 4
            }
          },
          {
            "id": 5658343512856320,
            "definition": {
              "title": "Container Mem Usage (%)",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "vertical",
              "legend_columns": [
                "avg"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "alias": "Memory Usage",
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "query": "sum:gcp.gke.container.memory.limit_utilization{cluster_name:${var.cluster_name}} by {container_name}",
                      "data_source": "metrics",
                      "name": "query1"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "warm",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "label": "",
                "min": "auto",
                "max": "auto"
              },
              "markers": [
                {
                  "label": " usage = 90% ",
                  "value": "y = 90",
                  "display_type": "error dashed"
                }
              ]
            },
            "layout": {
              "x": 4,
              "y": 0,
              "width": 4,
              "height": 4
            }
          },
          {
            "id": 1213166419999695,
            "definition": {
              "title": "Container states",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "vertical",
              "legend_columns": [
                "value"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "alias": "Ready",
                      "formula": "query1"
                    },
                    {
                      "alias": "Running",
                      "formula": "query2"
                    },
                    {
                      "alias": "Terminated",
                      "formula": "query3"
                    },
                    {
                      "alias": "Waiting",
                      "formula": "query4"
                    }
                  ],
                  "queries": [
                    {
                      "query": "sum:kubernetes_state.container.ready{cluster-name:${var.cluster_name}}",
                      "data_source": "metrics",
                      "name": "query1"
                    },
                    {
                      "query": "sum:kubernetes_state.container.running{cluster-name:${var.cluster_name}}",
                      "data_source": "metrics",
                      "name": "query2"
                    },
                    {
                      "query": "sum:kubernetes_state.container.terminated{cluster-name:${var.cluster_name}}",
                      "data_source": "metrics",
                      "name": "query3"
                    },
                    {
                      "query": "sum:kubernetes_state.container.waiting{cluster-name:${var.cluster_name}}",
                      "data_source": "metrics",
                      "name": "query4"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "orange",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ],
              "yaxis": {
                "include_zero": true,
                "scale": "linear",
                "label": "",
                "min": "auto",
                "max": "auto"
              },
              "markers": []
            },
            "layout": {
              "x": 8,
              "y": 0,
              "width": 4,
              "height": 4
            }
          },
          {
            "id": 6039336923588824,
            "definition": {
              "title": "CPU Intensive Containers",
              "title_size": "16",
              "title_align": "left",
              "type": "toplist",
              "requests": [
                {
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "sum:kubernetes.cpu.usage.total{cluster_name:${var.cluster_name}} by {container_name}",
                      "aggregator": "avg"
                    }
                  ],
                  "formulas": [
                    {
                      "formula": "query1",
                      "limit": {
                        "count": 10,
                        "order": "desc"
                      }
                    }
                  ],
                  "response_format": "scalar"
                }
              ],
              "style": {
                "display": {
                  "type": "stacked",
                  "legend": "inline"
                }
              }
            },
            "layout": {
              "x": 0,
              "y": 4,
              "width": 4,
              "height": 3
            }
          },
          {
            "id": 3691960013593256,
            "definition": {
              "title": "Memory Intensive Containers",
              "title_size": "16",
              "title_align": "left",
              "type": "toplist",
              "requests": [
                {
                  "queries": [
                    {
                      "data_source": "metrics",
                      "name": "query1",
                      "query": "sum:gcp.gke.container.memory.used_bytes{cluster_name:${var.cluster_name}} by {container_name}.weighted()",
                      "aggregator": "avg"
                    }
                  ],
                  "formulas": [
                    {
                      "formula": "query1",
                      "limit": {
                        "count": 10,
                        "order": "desc"
                      }
                    }
                  ],
                  "response_format": "scalar"
                }
              ],
              "style": {
                "display": {
                  "type": "stacked",
                  "legend": "inline"
                }
              }
            },
            "layout": {
              "x": 4,
              "y": 4,
              "width": 4,
              "height": 3
            }
          },
          {
            "id": 7004900209096528,
            "definition": {
              "title": "Container Restarts",
              "title_size": "16",
              "title_align": "left",
              "show_legend": true,
              "legend_layout": "vertical",
              "legend_columns": [
                "value"
              ],
              "type": "timeseries",
              "requests": [
                {
                  "formulas": [
                    {
                      "alias": "Restarts",
                      "formula": "query1"
                    }
                  ],
                  "queries": [
                    {
                      "name": "query1",
                      "data_source": "metrics",
                      "query": "sum:gcp.gke.container.restart_count.delta{cluster_name:${var.cluster_name}} by {container_name,pod_name,namespace_name}"
                    }
                  ],
                  "response_format": "timeseries",
                  "style": {
                    "palette": "dog_classic",
                    "line_type": "solid",
                    "line_width": "normal"
                  },
                  "display_type": "line"
                }
              ]
            },
            "layout": {
              "x": 8,
              "y": 4,
              "width": 4,
              "height": 3
            }
          }
        ]
      },
      "layout": {
        "x": 0,
        "y": 13,
        "width": 12,
        "height": 8,
        "is_column_break": true
      }
    }
  ],
  "template_variables": [],
  "layout_type": "ordered",
  "notify_list": [],
  "reflow_type": "fixed",
  "tags": []
}
EOF
}
