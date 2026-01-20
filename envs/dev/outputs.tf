output "project_id" {
  value       = var.project_id
  description = "Dev project ID."
}

output "spoke_network_self_link" {
  value       = module.network_spoke.network_self_link
  description = "Dev spoke network self link."
}

output "spoke_subnet_self_links" {
  value       = module.network_spoke.subnet_self_links
  description = "Dev spoke subnet self links."
}

output "gke_cluster_name" {
  value       = module.gke.cluster_name
  description = "GKE cluster name."
}

output "gke_endpoint" {
  value       = module.gke.endpoint
  description = "GKE endpoint."
}

output "gke_location" {
  value       = module.gke.location
  description = "GKE location."
}

output "gke_node_pool_name" {
  value       = module.gke.node_pool_name
  description = "GKE node pool name."
}

output "vm_instance_id" {
  value       = module.vm.instance_id
  description = "VM instance ID."
}

output "vm_internal_ip" {
  value       = module.vm.internal_ip
  description = "VM internal IP."
}

output "vm_service_account" {
  value       = module.vm_sa.email
  description = "VM service account email."
}
