# Technical Decisions

## ADR-001: Terraform over Pulumi

**Status:** Accepted

**Context:** Need to provision GCP infrastructure in a declarative and versioned way.

**Decision:** Use Terraform with HCL.

**Rationale:**
- Terraform is the industry standard for multi-cloud IaC
- Declarative HCL makes desired state readable and auditable
- Larger ecosystem of providers and modules
- GCS state locking prevents concurrent apply races
- Lower learning curve for heterogeneous teams

**Consequences:** HCL is less flexible than general-purpose languages, but sufficient for data infrastructure.

## ADR-002: Remote State in GCS

**Status:** Accepted

**Context:** Managing Terraform state in a collaborative environment.

**Decision:** Store state in Cloud Storage with native locking.

**Rationale:**
- Automatic state locking prevents concurrent applies
- Bucket versioning enables state rollback
- No additional cost (GCS buckets are cheap)
- Native integration with GCP

## ADR-003: Modular Structure

**Status:** Accepted

**Context:** Code organization for reuse and maintainability.

**Decision:** Each resource (storage, bigquery, pubsub, iam) as an independent module.

**Rationale:**
- Reuse across projects and environments
- Isolated testing per module
- Flexible composition (instantiate only what is needed)
- Single responsibility facilitates code review
