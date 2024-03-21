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

variable "vpc_name" {
  default = {
    development = "development"
    production  = ""
  }
}

variable "subnet_cidr" {
  default = {
    development = "10.0.0.0/16"
    production  = "10.1.0.0/16"
  }
}

variable "pods_cidr" {
  default = {
    development = "172.16.0.0/16"
    production  = "172.17.0.0/16"
  }
}

variable "services_cidr" {
  default = {
    development = "172.18.0.0/24"
    production  = "172.19.0.0/24"
  }
}

variable "network_tier" {
  default = {
    development = "STANDARD"
    production  = "PREMIUM"
  }
}
