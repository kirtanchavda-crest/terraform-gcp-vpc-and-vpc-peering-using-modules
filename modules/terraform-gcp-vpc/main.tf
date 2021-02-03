locals {
  ip_ranges = {
    public = tolist(toset(var.ip_ranges.public))
    private = {
      primary = var.ip_ranges.private_primary
    }
  }
}

resource "random_string" "network_suffix" {
  upper   = false
  lower   = true
  special = false
  length  = 2
}


// Create VPC network
resource "google_compute_network" "vpc" {
  name                            = "${var.name}-vpc"
  routing_mode                    = var.vpc_routing_mode
  description                     = var.vpc_description
  auto_create_subnetworks         = var.auto_create_subnetworks
  delete_default_routes_on_create = var.delete_default_internet_gateway_routes
  mtu = var.mtu
  timeouts {
    create = var.vpc_timeout
    update = var.vpc_timeout
    delete = var.vpc_timeout
  }
}


// Create public subnets
resource "google_compute_subnetwork" "public_subnets" {
  for_each                 = toset(local.ip_ranges.public)
  name                     = format("%s-%s-%d",var.name_public_subnets, random_string.network_suffix.result, index(local.ip_ranges.public, each.value) + 1)
  description              = var.public_subnet_description
  network                  = google_compute_network.vpc.self_link
  region                   = var.region
  private_ip_google_access = var.private_ip_google_access
  ip_cidr_range            = each.value
  timeouts {
    create = var.subnet_timeout
    update = var.subnet_timeout
    delete = var.subnet_timeout
  }
}


// Create private subnet
resource "google_compute_subnetwork" "private_subnet" {
  name                     = "${var.name_private_subnet}-${random_string.network_suffix.result}"
  description              = var.private_subnet_description
  network                  = google_compute_network.vpc.self_link
  region                   = var.region
  private_ip_google_access = var.private_ip_google_access
  ip_cidr_range            = local.ip_ranges.private.primary

  timeouts {
    create = var.subnet_timeout
    update = var.subnet_timeout
    delete = var.subnet_timeout
  }
}