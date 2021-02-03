# allow http traffic
resource "google_compute_firewall" "allow-http" {
  name    = "${var.name}-fw-allow-http"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  target_tags = ["http"]
}


# allow https traffic
resource "google_compute_firewall" "allow-https" {
  name    = "${var.name}-fw-allow-https"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  target_tags = ["https"]
}


# allow ssh traffic
resource "google_compute_firewall" "allow-ssh" {
  name    = "${var.name}-fw-allow-ssh"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  target_tags = ["ssh"]
}


# allow rdp traffic
resource "google_compute_firewall" "allow-rdp" {
  name    = "${var.name}-fw-allow-rdp"
  network = google_compute_network.vpc.name
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }
  target_tags = ["rdp"]
}