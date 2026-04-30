# Terraform - Plataforma de Dados GCP

Infraestrutura como Codigo para plataforma de dados completa no Google Cloud Platform. Terraform modules reutilizaveis com remote state no Cloud Storage.

## Arquitetura

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

| Module | Recurso | Descricao |
|--------|---------|-----------|
| `modules/storage` | `google_storage_bucket` | Bucket com versioning, lifecycle rules, uniform access |
| `modules/bigquery` | `google_bigquery_dataset`, `google_bigquery_table` | Dataset particionado com schema |
| `modules/pubsub` | `google_pubsub_topic`, `google_pubsub_subscription` | Topic + subscription com DLQ e retry policy |
| `modules/iam` | `google_service_account`, `google_project_iam_binding` | Service account com least-privilege |

## Prerequisitos

- Terraform >= 1.5
- Google Cloud SDK (`gcloud`)
- Projeto GCP com billing habilitado
- Service account com roles: `roles/owner` (ou granulares)

## Como Usar

```bash
# Clone
git clone https://github.com/DiegoSVBrito/terraform-gcp-data-platform.git
cd terraform-gcp-data-platform

# Configure credenciais
gcloud auth application-default login

# Copie e ajuste as variaveis
cp terraform.tfvars.example terraform.tfvars

# Inicialize (configura remote state no GCS)
terraform init

# Veja o plano de execucao
terraform plan

# Aplique a infraestrutura
terraform apply
```

## Decisoes Tecnicas

**Por que Terraform e nao Pulumi?** Terraform e o padrao da industria para IaC em GCP. HCL e declarativo, o que torna o estado desejado legivel. Pulumi exige linguagem de programacao geral, o que adiciona complexidade desnecessaria para infraestrutura de dados. O estado do Terraform e auditavel e previsivel.

**Por que remote state no GCS?** State locking nativo via Cloud Storage previne corridas de aplicacao. Em equipe, o remote state garante que todos trabalham sobre o mesmo estado. O versioning do bucket permite rollback do estado em caso de corrupcao.

**Por que estrutura modular?** Cada recurso (storage, bigquery, pubsub, iam) e um modulo independente. Isso permite reuso entre projetos, testes isolados e composicao flexivel. Adicionar um novo ambiente (staging/production) e apenas instanciar os mesmos modules com variaveis diferentes.

## Estrutura

```
terraform-gcp-data-platform/
  main.tf                  # Root module - composicao
  variables.tf             # Variaveis de entrada
  outputs.tf               # Outputs
  backend.tf               # Remote state config
  terraform.tfvars.example # Exemplo de valores
  modules/
    storage/               # GCS bucket
    bigquery/              # Dataset + tabelas
    pubsub/                # Topic + subscription + DLQ
    iam/                   # Service account + IAM
  docs/
    decisions.md           # Architecture Decision Records
  .github/
    workflows/
      terraform.yml        # CI/CD pipeline
```

---

**Autor:** Diego Brito
