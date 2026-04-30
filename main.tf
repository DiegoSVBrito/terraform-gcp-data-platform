# Root module - composicao da infraestrutura de dados GCP

terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# Data Lake Storage
module "storage" {
  source = "./modules/storage"

  project_id = var.project_id
  region     = var.region
  env        = var.environment
  name       = var.bucket_name
}

# BigQuery Dataset + Tables
module "bigquery" {
  source = "./modules/bigquery"

  project_id  = var.project_id
  region      = var.region
  env         = var.environment
  dataset_id  = var.dataset_id
}

# Pub/Sub Topic + Subscription + DLQ
module "pubsub" {
  source = "./modules/pubsub"

  project_id    = var.project_id
  region        = var.region
  env           = var.environment
  topic_name    = var.topic_name
}

# IAM - Service Account + Roles
module "iam" {
  source = "./modules/iam"

  project_id   = var.project_id
  env          = var.environment
  dataset_id   = var.dataset_id
  bucket_name  = var.bucket_name
  topic_name   = var.topic_name
}
