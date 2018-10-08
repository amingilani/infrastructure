/* This configuration sets up a Kubernetes Cluster following
   https://www.doxsey.net/blog/kubernetes--the-surprisingly-affordable-platform-for-personal-projects

   TODO:
   - disable stackdriver
    */

provider "google" {
  credentials = "${file("secret-account.json")}"
  project     = "worklark-218609"
  zone        = "us-central1-a"
}

# Node pool configuration
resource "google_container_node_pool" "np" {
  name       = "worklark-node-pool"
  cluster    = "${google_container_cluster.primary.name}"
  node_count = 3

  node_config {
    machine_type = "f1-micro"
    disk_size_gb = 10         # Set the initial disk size
    preemptible  = true
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

# configuration
resource "google_container_cluster" "primary" {
  name               = "worklark-cluster"
  logging_service    = "none"
  monitoring_service = "none"

  addons_config {
    kubernetes_dashboard {
      disabled = false # Configure the Kubernetes dashboard
    }

    http_load_balancing {
      disabled = false # Configure the Kubernetes dashboard
    }
  }

  lifecycle {
    ignore_changes = ["node_pool"]
  }

  node_pool {
    name = "default-pool"
  }
}

resource "google_compute_firewall" "default" {
  name        = "http-https"
  network     = "${google_container_cluster.primary.network}"
  description = "Enable HTTP and HTTPS access"

  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }
}
