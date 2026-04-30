terraform {
  backend "gcs" {
    bucket = "terraform-state-data-platform"
    prefix = "terraform/state"
  }
}
