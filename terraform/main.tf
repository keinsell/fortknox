terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.12.0"
    }
  }
  required_version = ">= 0.13"
}

variable "scaleway_region" {
  type        = string
  description = "Scaleway region"
  default     = "pl-waw"
}

variable "scaleway_zone" {
  type        = string
  description = "Scaleway zone"
  default     = "pl-waw-1"
}

variable "scaleway_project" {
  type        = string
  description = "Scaleway project id"
  default     = "d25f8b4c-71cc-463a-9ec9-b193a5d4c04a"
}

variable "scaleway_access_key" {
  type        = string
  description = "Scaleway access key"
}

variable "scaleway_secret_key" {
  type        = string
  description = "Scaleway secret key"
}


provider "scaleway" {
  region     = var.scaleway_region
  access_key = var.scaleway_access_key
  secret_key = var.scaleway_secret_key
  project_id = var.scaleway_project
}


resource "scaleway_k8s_cluster" "wisebear" {
  name                        = "wisebear"
  version                     = "1.24.3"
  cni                         = "cilium"
  delete_additional_resources = false
}

resource "scaleway_k8s_pool" "dummycat" {
  depends_on = [scaleway_k8s_cluster.wisebear]
  cluster_id = scaleway_k8s_cluster.wisebear.id
  region     = "pl-waw"
  name       = "dummycat"
  node_type  = "PLAY2-NANO"
  size       = 1
  zone       = var.scaleway_zone

  # provisioner "local-exec" {
  #   command = "mkdir -p ${path.module}/kubeconfig && scaleway k8s kubeconfig create ${scaleway_k8s_cluster.ple8697573.id} --output-type=kubeconfig > ${path.module}/kubeconfig/kubeconfig_${scaleway_k8s_cluster.ple8697573.id}.yaml"
  # }
}

