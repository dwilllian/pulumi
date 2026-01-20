output "cluster_name" {
  value       = google_container_cluster.this.name
  description = "Cluster name."
}

output "endpoint" {
  value       = google_container_cluster.this.endpoint
  description = "Cluster endpoint."
}

output "location" {
  value       = google_container_cluster.this.location
  description = "Cluster location."
}

output "node_pool_name" {
  value       = google_container_node_pool.primary.name
  description = "Node pool name."
}

output "node_pool_self_link" {
  value       = google_container_node_pool.primary.self_link
  description = "Node pool self link."
}
