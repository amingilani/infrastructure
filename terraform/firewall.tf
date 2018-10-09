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
