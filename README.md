# Terraform - GCP Data Platform

Infrastructure as Code for a complete data platform on Google Cloud Platform. Reusable Terraform modules with remote state in Cloud Storage.

## Architecture

```
                    +---------------------------+
                    |        Terraform CLI      |
                    |    (plan / apply / destroy)|
                    +-------------+-------------+
                                  |
                    +-------------v-------------+
                    |     GCS Remote State      |
                    |   (terraform.tfstate)     |
                    +-------------+-------------+
                                  |
          +-----------+-----------+-----------+-----------+
          |           |           |           |           |
    +-----v----+ +----v-----+ +--v-------+ +v---------+ +v--------+
    |  Cloud   | | BigQuery | | Pub/Sub  | |  Cloud   | |   IAM   |
    | Storage  | | Dataset  | | Topic +  | |Composer  | | Service |
    | (Data    | | + Tables | | Sub +    | |(Airflow) | | Account |
    |  Lake)   | |          | | DLQ      | |          | | + Roles |
    +----------+ +----------+ +----------+ +----------+ +---------+
```

## Modules

| Module | Resource | Description |
|--------|----------|-------------|
| `modules/storage` | `google_storage_bucket` | Bucket with versioning, lifecycle rules, uniform access |
| `modules/bigquery` | `google_bigquery_dataset`, `google_bigquery_table` | Partitioned dataset with schema |
| `modules/pubsub` | `google_pubsub_topic`, `google_pubsub_subscription` | Topic + subscription with DLQ and retry policy |
| `modules/iam` | `google_service_account`, `google_project_iam_binding` | Service account with least-privilege roles |

## Prerequisites

- Terraform >= 1.5
- Google Cloud SDK (`gcloud`)
- GCP project with billing enabled
- Service account with appropriate roles

## Usage

```bash
git clone https://github.com/DiegoSVBrito/terraform-gcp-data-platform.git
cd terraform-gcp-data-platform

gcloud auth application-default login

cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your project values

terraform init
terraform plan
terraform apply
```

## Technical Decisions

**Why Terraform over Pulumi?** Terraform is the industry standard for IaC on GCP. HCL is declarative, making the desired state readable and auditable. Pulumi requires a general-purpose language, adding unnecessary complexity for data infrastructure. Terraform state is auditable and predictable.

**Why remote state in GCS?** Native state locking via Cloud Storage prevents apply races. In team settings, remote state ensures everyone works against the same state. Bucket versioning enables state rollback if corruption occurs.

**Why modular structure?** Each resource (storage, bigquery, pubsub, iam) is an independent module. This enables reuse across projects, isolated testing, and flexible composition. Adding a new environment (staging/production) is just instantiating the same modules with different variables.

## Structure

```
terraform-gcp-data-platform/
  main.tf                  # Root module - composition
  variables.tf             # Input variables
  outputs.tf               # Outputs
  backend.tf               # Remote state config
  terraform.tfvars.example # Example values
  modules/
    storage/               # GCS bucket
    bigquery/              # Dataset + tables
    pubsub/                # Topic + subscription + DLQ
    iam/                   # Service account + IAM
  docs/
    decisions.md           # Architecture Decision Records
  .github/
    workflows/
      terraform.yml        # CI/CD pipeline
```

---

Author: Diego Brito
