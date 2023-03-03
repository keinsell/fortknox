terraform {
  cloud {
    organization = "keinsell"
    workspaces {
      name = "fortknox"
    }
  }
  required_providers {
    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.12.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
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

provider "random" {
  # Configuration options
}

resource "random_pet" "cluster" {
}

resource "random_pet" "pool" {
}


resource "scaleway_k8s_cluster" "cluster" {
  project_id                  = var.scaleway_project
  name                        = random_pet.cluster.id
  version                     = "1.24.3"
  cni                         = "cilium"
  delete_additional_resources = true
}

resource "scaleway_k8s_pool" "pool" {
  depends_on          = [scaleway_k8s_cluster.cluster]
  cluster_id          = scaleway_k8s_cluster.cluster.id
  region              = var.scaleway_region
  name                = random_pet.pool.id
  node_type           = "PLAY2-NANO"
  size                = 1
  zone                = var.scaleway_zone
  wait_for_pool_ready = true
}

output "kubeconfig" {
  value     = scaleway_k8s_cluster.cluster.kubeconfig
  sensitive = true
}
