output "router_name" {
  value       = try(google_compute_router.this[0].name, null)
  description = "Cloud Router name."
}

output "nat_name" {
  value       = try(google_compute_router_nat.this[0].name, null)
  description = "Cloud NAT name."
}
