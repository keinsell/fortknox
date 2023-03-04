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

resource "mongodbatlas_project" "fortknox" {
  org_id = var.mongodb_org_id
  name   = "fortknox"
}

resource "mongodbatlas_cluster" "fortknox" {
  project_id = mongodbatlas_project.fortknox.id
  name       = random_pet.database_cluster.id

  provider_name               = "TENANT"
  backing_provider_name       = "AWS"
  provider_region_name        = "US_EAST_1"
  provider_instance_size_name = "M0"
}

data "mongodbatlas_cluster" "fortknox" {
  depends_on = [mongodbatlas_cluster.fortknox]
  project_id = mongodbatlas_cluster.fortknox.project_id
  name       = mongodbatlas_cluster.fortknox.name
}

resource "mongodbatlas_database_user" "user" {
  username           = var.database_user
  password           = var.database_password
  project_id         = mongodbatlas_project.fortknox.id
  auth_database_name = "admin"

  roles {
    role_name     = "readWrite"
    database_name = var.database_name
  }
  labels {
    key   = "Name"
    value = "Default User"
  }
}

resource "mongodbatlas_project_ip_access_list" "ip" {
  project_id = mongodbatlas_project.fortknox.id
  cidr_block = "0.0.0.0/0"
  comment    = "IP Address for accessing the cluster"
}
