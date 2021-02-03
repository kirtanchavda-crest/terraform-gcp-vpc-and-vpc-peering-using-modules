locals {
  local_network_name = element(reverse(split("/", var.local_network)), 0)
  peer_network_name  = element(reverse(split("/", var.peer_network)), 0)

  local_network_peering      = "${var.prefix}-${local.local_network_name}-${local.peer_network_name}"
  local_network_peering_name = length(local.local_network_peering) < 63 ? local.local_network_peering : "${substr(local.local_network_peering, 0, min(58, length(local.local_network_peering)))}-${random_string.network_peering_suffix.result}"
  
  peer_network_peering       = "${var.prefix}-${local.peer_network_name}-${local.local_network_name}"
  peer_network_peering_name  = length(local.peer_network_peering) < 63 ? local.peer_network_peering : "${substr(local.peer_network_peering, 0, min(58, length(local.peer_network_peering)))}-${random_string.network_peering_suffix.result}"
}

resource "random_string" "network_peering_suffix" {
  upper   = false
  lower   = true
  special = false
  length  = 4
}

resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "30s"
}

resource "google_compute_network_peering" "local_network_peering" {
  name                 = local.local_network_peering_name
  network              = var.local_network
  peer_network         = var.peer_network
  export_custom_routes = var.export_local_custom_routes
  import_custom_routes = var.export_peer_custom_routes

  depends_on = [null_resource.module_depends_on, time_sleep.wait_30_seconds]
}

resource "google_compute_network_peering" "peer_network_peering" {
  name                 = local.peer_network_peering_name
  network              = var.peer_network
  peer_network         = var.local_network
  export_custom_routes = var.export_peer_custom_routes
  import_custom_routes = var.export_local_custom_routes

  depends_on = [null_resource.module_depends_on, google_compute_network_peering.local_network_peering]
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

resource "null_resource" "complete" {
  depends_on = [google_compute_network_peering.local_network_peering, google_compute_network_peering.peer_network_peering]
}