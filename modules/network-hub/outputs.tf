output "network_name" {
  value       = google_compute_network.this.name
  description = "Hub network name."
}

output "network_self_link" {
  value       = google_compute_network.this.self_link
  description = "Hub network self link."
}

output "subnet_self_links" {
  value       = { for name, subnet in google_compute_subnetwork.subnets : name => subnet.self_link }
  description = "Map of subnet self links."
}

output "subnet_cidrs" {
  value       = { for name, subnet in google_compute_subnetwork.subnets : name => subnet.ip_cidr_range }
  description = "Map of subnet CIDR ranges."
}
