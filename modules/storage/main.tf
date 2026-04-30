resource "google_storage_bucket" "data_lake" {
  name          = "${var.name}-${var.project_id}"
  location      = var.region
  force_destroy = var.env == "dev" ? true : false

  uniform_bucket_level_access = true
  versioning {
    enabled = true
  }

  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }

  lifecycle_rule {
    condition {
      age = 365
    }
    action {
      type = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }

  labels = {
    environment = var.env
    managed_by  = "terraform"
  }
}
