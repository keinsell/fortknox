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
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.8.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }
  }
  required_version = ">= 1.0"
}


resource "random_pet" "cluster" {
}

resource "random_pet" "pool" {
}
resource "random_pet" "database_cluster" {
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

resource "mongodbatlas_project" "mongodb_project" {
  org_id = var.mongodb_org_id
  name   = "fortknox"
}

resource "mongodbatlas_cluster" "mongodb" {
  project_id = mongodbatlas_project.mongodb_project.id
  name       = random_pet.database_cluster.id

  provider_name               = "TENANT"
  backing_provider_name       = "AWS"
  provider_region_name        = "US_EAST_1"
  provider_instance_size_name = "M0"
}
