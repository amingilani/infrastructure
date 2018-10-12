# based on the instructions under at
# https://web.archive.org/web/20181012004032/https://cloud.google.com/sql/docs/postgres/connect-kubernetes-engine

resource "google_service_account" "cluster_account" {
  account_id   = "cluster-account"
  display_name = "Cluster account"
}

resource "google_project_iam_binding" "cluster_account_iam" {
    role = "roles/cloudsql.client"
    members = [
      "serviceAccount:${google_service_account.cluster_account.email}",
    ]
}

resource "google_service_account_key" "cluster_key" {
  service_account_id = "${google_service_account.cluster_account.name}"
}

resource "kubernetes_secret" "cluster_account_credentials" {
  metadata {
    name = "cluster-account-credentials"
  }
  data {
    credentials.json = "${base64decode(google_service_account_key.cluster_key.private_key)}"
  }
}
