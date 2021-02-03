output "network" {
  description = "A reference (self_link) to the VPC network."
  value       = google_compute_network.vpc.self_link
}

output "network_name" {
  description = "The generated name of the VPC network."
  value       = google_compute_network.vpc.name
}

output "network_id" {
  description = "The identifier of the VPC network with format projects/{{project}}/global/networks/{{name}}."
  value       = google_compute_network.vpc.id
}

output "public_subnets" {
  description = "References (self_link) to the Public SubNetworks."
  value = [
    for public_subnet in google_compute_subnetwork.public_subnets : public_subnet.self_link
  ]
}

output "private_subnet" {
  description = "A reference (self_link) to the Private SubNetwork."
  value       = google_compute_subnetwork.private_subnet.self_link
}