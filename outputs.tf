output "bucket_url" {
  description = "URL do bucket GCS"
  value       = module.storage.bucket_url
}

output "dataset_id" {
  description = "ID do dataset BigQuery"
  value       = module.bigquery.dataset_id
}

output "topic_name" {
  description = "Nome do topico Pub/Sub"
  value       = module.pubsub.topic_name
}

output "service_account_email" {
  description = "Email da service account"
  value       = module.iam.service_account_email
}
