provider "google-beta" {
  project = "test-sql-project-305022"
  region  = "us-central1"
}

# Store Cloud Function Code
resource "google_storage_bucket" "bucket" {
  provider = google-beta
  name = "ice-cream-function-bucket"
}

resource "google_storage_bucket_object" "archive" {
  provider = google-beta
  name   = "get_reviews.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./reviews_get/get_reviews.zip"
}

# Create Cloud Function
resource "google_cloudfunctions_function" "function" {
  provider = google-beta
  name        = "function-test"
  description = "My function"
  runtime     = "nodejs10"

  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "reviewsGET"
}

resource "google_cloudfunctions_function_iam_binding" "binding" {
  provider = google-beta
  project = google_cloudfunctions_function.function.project
  region = google_cloudfunctions_function.function.region
  cloud_function = google_cloudfunctions_function.function.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}


resource "google_api_gateway_api" "api_gw" {
  provider = google-beta
  api_id = "main-gateway"
}

resource "google_api_gateway_api_config" "api_gw" {
  provider = google-beta
  api = google_api_gateway_api.api_gw.api_id
  api_config_id = "config"

  openapi_documents {
    document {
      path = "spec.yaml"
      contents = filebase64("api_spec.yaml")
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "google_api_gateway_gateway" "api_gw" {
  provider = google-beta
  api_config = google_api_gateway_api_config.api_gw.id
  gateway_id = "my-gateway"
}

output "deployed_function_url" {
  value = google_cloudfunctions_function.function.https_trigger_url
}
