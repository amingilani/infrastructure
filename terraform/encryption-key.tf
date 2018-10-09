resource "google_kms_key_ring" "worklark_key_ring" {
  name     = "worklark-key-ring"
  location = "us-central1"
}

resource "google_kms_crypto_key" "terraform_key" {
  name     = "terraform-key"
  key_ring = "${google_kms_key_ring.worklark_key_ring.id}"
}
