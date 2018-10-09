resource "google_sql_database_instance" "master" {
  name = "master-instance"
  database_version = "POSTGRES_9_6"
  region = "us-central1"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "worklark" {
  name      = "worklark-production"
  instance  = "${google_sql_database_instance.master.name}"
}

resource "google_sql_user" "production_user" {
  depends_on = ["google_kms_crypto_key.terraform_key"]
  name     = "worklark-production-user"
  instance = "${google_sql_database_instance.master.name}"
  password = "${random_string.password.result}"
}

resource "kubernetes_secret" "production-database-user" {
  metadata {
    name = "production-database-credentials"
    }
  data {
    username = "${google_sql_user.production_user.name}"
    password = "${google_sql_user.production_user.password}"
    }
  }
