output "kubeconfig" {
  value     = scaleway_k8s_cluster.cluster.kubeconfig
  sensitive = true
}

output "mongodb_uri" {
  value     = mongodbatlas_cluster.fortknox.connection_strings[0].standard_srv
  sensitive = true
}
