/* This configuration sets up a Kubernetes Cluster following
   https://www.doxsey.net/blog/kubernetes--the-surprisingly-affordable-platform-for-personal-projects

   Confession: there's a minor difference between the article and my config, the
   former created a Cluster and configured the default node pool, however the options
   for doing this via the API are limited, so my configuration creates an empty
   default node pool for the cluster, and the creates and adds a fully configured
   one on top
    */

# Node pool configuration
resource "google_container_node_pool" "primary_pool" {
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
  network            = "projects/${var.project}/global/networks/default"

  addons_config {
    kubernetes_dashboard {
      disabled = false # Configure the Kubernetes dashboard
    }

    http_load_balancing {
      disabled = false # Configure the Kubernetes dashboard
    }
  }

  remove_default_node_pool = "true"

  lifecycle {
    ignore_changes = "node_pool"
  }

  node_pool {
    name = "default-pool"
  }
}
