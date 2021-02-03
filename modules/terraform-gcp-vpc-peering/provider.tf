// Configure terraform version
terraform {
  required_version = ">= 0.14.5" # see https://releases.hashicorp.com/terraform/
  required_providers {
    time = {
      source = "hashicorp/time"
      version = "0.6.0"
    }
  }
}

// Configure the Google Cloud provider
provider "google" {
  credentials = file(var.credentials)
  project     = var.gcp_project
  region      = var.region
}

provider "google-beta" {
  credentials = file(var.credentials)
  project     = var.gcp_project
  region      = var.region
}