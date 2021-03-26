provider "google-beta" {
  project = "ice-cream-project-308820"
  region  = "us-central1"
}

######
#
# MAKE VPC
#
######
resource "google_compute_network" "private_network" {
  provider = google-beta

  name = "private-network"
}

resource "google_compute_global_address" "private_ip_address" {
  provider = google-beta

  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.id
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta

  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_vpc_access_connector" "connector" {
  provider      = google-beta
  name          = "vpc-con"
  ip_cidr_range = "10.8.0.0/28"
  network       = google_compute_network.private_network.name
}

######
#
# MAKE DATABASE
#
######
resource "google_sql_database_instance" "instance" {
  provider = google-beta

  name   = "icecreamdb-tf"
  region = "us-central1"
  database_version = "MYSQL_8_0"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.private_network.id
    }
  }

  deletion_protection = true
  lifecycle {
    # prevent_destroy = true
    ignore_changes = all
  }
}

# resource "google_sql_user" "users" {
#   provider = google-beta
#   name     = "testuser"
#   instance = google_sql_database_instance.instance.name
#   password = "testuser"
#   lifecycle {
#     ignore_changes = []"*"
#   }
# }

######
#
# STORE CLOUD FUNCTION
#
######
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

######
#
# MAKE CLOUD FUNCTION
#
######
resource "google_cloudfunctions_function" "function" {
  provider = google-beta
  name        = "function-test"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  trigger_http          = true
  entry_point           = "reviewsGET"
}

resource "google_cloudfunctions_function_iam_binding" "binding" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

output "function_url" {
  value = google_cloudfunctions_function.function.https_trigger_url
}

######
#
# CREATE API GATEWAY
#
######
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

output "gateway_url" {
  value = google_api_gateway_gateway.api_gw.default_hostname
}