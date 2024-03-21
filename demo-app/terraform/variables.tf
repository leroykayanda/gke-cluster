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

variable "service" {
  type    = string
  default = "demo-app"
}
