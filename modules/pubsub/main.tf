resource "google_pubsub_topic" "main" {
  name    = "${var.topic_name}-${var.env}"
  project = var.project_id

  message_retention_duration = "86400s"

  labels = {
    environment = var.env
    managed_by  = "terraform"
  }
}

resource "google_pubsub_subscription" "main" {
  name    = "${var.topic_name}-${var.env}-sub"
  project = var.project_id
  topic   = google_pubsub_topic.main.name

  ack_deadline_seconds = 60

  retry_policy {
    minimum_backoff = "10s"
    maximum_backoff = "600s"
  }

  dead_letter_policy {
    dead_letter_topic     = google_pubsub_topic.dlq.id
    max_delivery_attempts = 5
  }
}

resource "google_pubsub_topic" "dlq" {
  name    = "${var.topic_name}-${var.env}-dlq"
  project = var.project_id

  labels = {
    environment = var.env
    type        = "dead-letter"
    managed_by  = "terraform"
  }
}
