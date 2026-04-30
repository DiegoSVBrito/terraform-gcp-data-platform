variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-east1"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "Nome do bucket GCS para data lake"
  type        = string
}

variable "dataset_id" {
  description = "ID do dataset BigQuery"
  type        = string
}

variable "topic_name" {
  description = "Nome do topico Pub/Sub"
  type        = string
}
