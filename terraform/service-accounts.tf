resource "google_service_account" "cluster_account" {
  account_id   = "cluster-account"
  display_name = "Cluster account"
}

resource "google_service_account_key" "cluster_key" {
  service_account_id = "${google_service_account.cluster_account.name}"
}

resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name = "google-application-credentials"
  }
  data {
    credentials.json = "${base64decode(google_service_account_key.cluster_key.private_key)}"
  }
}
