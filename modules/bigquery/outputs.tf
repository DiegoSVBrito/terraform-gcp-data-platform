output "dataset_id" {
  value = google_bigquery_dataset.dataset.dataset_id
}

output "table_id" {
  value = google_bigquery_table.events.table_id
}
