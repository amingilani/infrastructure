resource "random_string" "password" {
  length  = 32
  special = false
}

resource "random_string" "id" {
  length  = 8
  upper   = false
  lower   = false
  special = false
}
