# Decisoes Tecnicas

## ADR-001: Terraform over Pulumi

**Status:** Aceito

**Contexto:** Necessidade de provisionar infraestrutura GCP de forma declarativa e versionavel.

**Decisao:** Utilizar Terraform com HCL.

**Motivos:**
- Terraform e o padrao da industria para IaC multi-cloud
- HCL declarativo torna o estado desejado legivel e auditavel
- Maior ecossistema de providers e modules
- State locking via GCS previne corridas
- Curva de aprendizado menor para equipes heterogeneas

**Consequencias:** Sintaxe HCL menos flexivel que linguagens de programacao geral, mas suficiente para infraestrutura de dados.

## ADR-002: Remote State no GCS

**Status:** Aceito

**Contexto:** Gerenciamento de state do Terraform em ambiente colaborativo.

**Decisao:** Armazenar state no Cloud Storage com locking nativo.

**Motivos:**
- State locking automatico previne apply simultaneo
- Versioning do bucket permite rollback do state
- Sem custo adicional (bucket GCS e barato)
- Integracao nativa com GCP

## ADR-003: Estrutura Modular

**Status:** Aceito

**Contexto:** Organizacao do codigo Terraform para reuso e manutenibilidade.

**Decisao:** Cada recurso (storage, bigquery, pubsub, iam) como modulo independente.

**Motivos:**
- Reuso entre projetos e ambientes
- Testes isolados por modulo
- Composicao flexivel (instanciar apenas o necessario)
- Responsabilidade unica facilita revisao de codigo
