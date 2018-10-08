/* This configuration sets up a Kubernetes Cluster following
   https://www.doxsey.net/blog/kubernetes--the-surprisingly-affordable-platform-for-personal-projects

   TODO:
   - disable stackdriver
    */


provider "google" {
  credentials = "${file("account.json")}"
  project     = "my-gce-project-id"
  region      = "us-central1-a"
}

# configuration
resource "google_container_cluster" "primary" {
  name               = "gke-example"
  zone               = "europe-west2-a"
  initial_node_count = 3
  machine_type = "f1-micro"
  preemptible = true

  addons_config {
    kubernetes_dashboard {
      disabled = false # Configure the Kubernetes dashboard
    }

    http_load_balancing {
      disabled = false # Configure the Kubernetes dashboard
    }

  }

  node_config {
    disk_size_gb = "10GB" # Set the initial disk size
  }
}
