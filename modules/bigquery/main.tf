resource "google_bigquery_dataset" "dataset" {
  dataset_id    = "${var.dataset_id}_${var.env}"
  project       = var.project_id
  location      = var.region
  friendly_name = "Data Warehouse - ${var.env}"

  labels = {
    environment = var.env
    managed_by  = "terraform"
  }
}

resource "google_bigquery_table" "events" {
  dataset_id = google_bigquery_dataset.dataset.dataset_id
  project    = var.project_id
  table_id   = "events"

  time_partitioning {
    type                     = "DAY"
    field                    = "event_timestamp"
    require_partition_filter = true
  }

  clustering = ["event_type", "source"]

  schema = <<EOF
[
  {"name": "event_id",        "type": "STRING",  "mode": "REQUIRED"},
  {"name": "event_type",      "type": "STRING",  "mode": "REQUIRED"},
  {"name": "source",          "type": "STRING",  "mode": "NULLABLE"},
  {"name": "payload",         "type": "JSON",    "mode": "NULLABLE"},
  {"name": "event_timestamp", "type": "TIMESTAMP","mode": "REQUIRED"},
  {"name": "processed_at",    "type": "TIMESTAMP","mode": "NULLABLE"}
]
EOF

  labels = {
    environment = var.env
    managed_by  = "terraform"
  }
}
