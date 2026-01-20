output "instance_id" {
  value       = google_compute_instance.this.id
  description = "Instance ID."
}

output "self_link" {
  value       = google_compute_instance.this.self_link
  description = "Instance self link."
}

output "internal_ip" {
  value       = google_compute_instance.this.network_interface[0].network_ip
  description = "Internal IP."
}
