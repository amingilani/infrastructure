resource "google_sql_database_instance" "master" {
  name             = "master-instance"
  database_version = "POSTGRES_9_6"
  region           = "us-central1"

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "worklark" {
  name     = "worklark-production"
  instance = "${google_sql_database_instance.master.name}"
}

resource "google_sql_user" "production_user" {
  depends_on = ["google_kms_crypto_key.terraform_key"]
  name       = "worklark-production-user"
  instance   = "${google_sql_database_instance.master.name}"
  password   = "${random_string.password.result}"
}

resource "kubernetes_config_map" "production_database_host" {
  metadata {
    name = "production-database-host"
  }

  data {
    connection_name = "${google_sql_database_instance.master.connection_name}"
  }
}

resource "kubernetes_secret" "production_database_credentials" {
  metadata {
    name = "production-database-credentials"
  }

  data {
    database_url = "postgresql://${google_sql_user.production_user.name}:${google_sql_user.production_user.password}@127.0.0.1:5432/${google_sql_database.worklark.name}?encoding=utf8&pool=5&timeout=5000"
  }
}
