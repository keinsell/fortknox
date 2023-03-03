terraform {
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.12.0"
    }
  }
  required_version = ">= 1.0"
}



provider "scaleway" {
  region     = var.scaleway_region
  access_key = var.scaleway_access_key
  secret_key = var.scaleway_secret_key
  project_id = var.scaleway_project
  zone       = var.scaleway_zone
}


resource "scaleway_k8s_cluster" "wisebear" {
  project_id                  = var.scaleway_project
  name                        = "wisebear"
  version                     = "1.24.3"
  cni                         = "cilium"
  delete_additional_resources = true
}

resource "scaleway_k8s_pool" "dummycat" {
  # depends_on = [scaleway_k8s_cluster.wisebear]
  cluster_id          = scaleway_k8s_cluster.wisebear.id
  region              = var.scaleway_region
  name                = "dummycat"
  node_type           = "PLAY2-NANO"
  size                = 1
  zone                = var.scaleway_zone
  wait_for_pool_ready = true
}

output "kubeconfig" {
  value     = scaleway_k8s_cluster.wisebear.kubeconfig
  sensitive = true
}
