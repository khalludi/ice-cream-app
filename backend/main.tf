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

  name = "my-private-network"
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

  name   = "icecreamdb-custom-tf"
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
    # ignore_changes = all
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

######
#
# MAKE CLOUD FUNCTION
#
######

### Func 2 Adv Query
resource "google_storage_bucket_object" "archive2" {
  provider = google-beta
  name   = "adv_query_reviews.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./reviews_adv_query/adv_query_reviews.zip"
}

resource "google_cloudfunctions_function" "function2" {
  provider = google-beta
  name        = "function-user-adv-query"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive2.name
  trigger_http          = true
  entry_point           = "usersAdvQuery"
}

resource "google_cloudfunctions_function_iam_binding" "binding2" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function2.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Users Search
resource "google_storage_bucket_object" "archive3" {
  provider = google-beta
  name   = "user_search.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./user_search/user_search.zip"
}

resource "google_cloudfunctions_function" "function3" {
  provider = google-beta
  name        = "function-user-search"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive3.name
  trigger_http          = true
  entry_point           = "usersAdvQuery"
}

resource "google_cloudfunctions_function_iam_binding" "binding3" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function3.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Get User Profile
resource "google_storage_bucket_object" "archive4" {
  provider = google-beta
  name   = "get_profile.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./get_profile/get_profile.zip"
}

resource "google_cloudfunctions_function" "function4" {
  provider = google-beta
  name        = "function-get-profile"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive4.name
  trigger_http          = true
  entry_point           = "usersAdvQuery"
}

resource "google_cloudfunctions_function_iam_binding" "binding4" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function4.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Create User Profile
resource "google_storage_bucket_object" "archive5" {
  provider = google-beta
  name   = "create_profile.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./create_profile/create_profile.zip"
}

resource "google_cloudfunctions_function" "function5" {
  provider = google-beta
  name        = "function-create-profile"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive5.name
  trigger_http          = true
  entry_point           = "usersAdvQuery"
}

resource "google_cloudfunctions_function_iam_binding" "binding5" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function5.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Edit User Profile
resource "google_storage_bucket_object" "archive6" {
  provider = google-beta
  name   = "edit_profile.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./edit_profile/edit_profile.zip"
}

resource "google_cloudfunctions_function" "function6" {
  provider = google-beta
  name        = "function-edit-profile"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive6.name
  trigger_http          = true
  entry_point           = "usersAdvQuery"
}

resource "google_cloudfunctions_function_iam_binding" "binding6" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function6.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Delete User Profile
resource "google_storage_bucket_object" "archive7" {
  provider = google-beta
  name   = "delete_profile.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./delete_profile/delete_profile.zip"
}

resource "google_cloudfunctions_function" "function7" {
  provider = google-beta
  name        = "function-delete-profile"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive7.name
  trigger_http          = true
  entry_point           = "usersAdvQuery"
}

resource "google_cloudfunctions_function_iam_binding" "binding7" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function7.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Anna's Advanced Query
resource "google_storage_bucket_object" "archive8" {
  provider = google-beta
  name   = "aadvanced.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./aadvanced/aadvanced.zip"
}

resource "google_cloudfunctions_function" "function8" {
  provider = google-beta
  name        = "function-aadvanced"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive8.name
  trigger_http          = true
  entry_point           = "aadvQuery"
}

resource "google_cloudfunctions_function_iam_binding" "binding8" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function8.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Hannah's Advanced Query
resource "google_storage_bucket_object" "archive9" {
  provider = google-beta
  name   = "hadvanced.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./hadvanced/hadvanced.zip"
}

resource "google_cloudfunctions_function" "function9" {
  provider = google-beta
  name        = "function-hadvanced"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive9.name
  trigger_http          = true
  entry_point           = "hAdvQuery"
}

resource "google_cloudfunctions_function_iam_binding" "binding9" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function9.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Delete Review
resource "google_storage_bucket_object" "archive10" {
  provider = google-beta
  name   = "delete_review.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./delete_review/delete_review.zip"
}

resource "google_cloudfunctions_function" "function10" {
  provider = google-beta
  name        = "function-delete-review"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive10.name
  trigger_http          = true
  entry_point           = "deleteReview"
}

resource "google_cloudfunctions_function_iam_binding" "binding10" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function10.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Update Review
resource "google_storage_bucket_object" "archive11" {
  provider = google-beta
  name   = "update_review.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./update_review/update_review.zip"
}

resource "google_cloudfunctions_function" "function11" {
  provider = google-beta
  name        = "function-update-review"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive11.name
  trigger_http          = true
  entry_point           = "updateReview"
}

resource "google_cloudfunctions_function_iam_binding" "binding11" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function11.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Get Review Text
resource "google_storage_bucket_object" "archive12" {
  provider = google-beta
  name   = "get_review_text.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./get_review_text/get_review_text.zip"
}

resource "google_cloudfunctions_function" "function12" {
  provider = google-beta
  name        = "function-get-review-text"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive12.name
  trigger_http          = true
  entry_point           = "getReviewText"
}

resource "google_cloudfunctions_function_iam_binding" "binding12" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function12.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Get Review Text
resource "google_storage_bucket_object" "archive13" {
  provider = google-beta
  name   = "get_review_key.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./get_review_key/get_review_key.zip"
}

resource "google_cloudfunctions_function" "function13" {
  provider = google-beta
  name        = "function-get-review-key"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive13.name
  trigger_http          = true
  entry_point           = "getReviewKey"
}

resource "google_cloudfunctions_function_iam_binding" "binding13" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function13.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Get Review All
resource "google_storage_bucket_object" "archive14" {
  provider = google-beta
  name   = "get_review_all.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./get_review_all/get_review_all.zip"
}

resource "google_cloudfunctions_function" "function14" {
  provider = google-beta
  name        = "function-get-review-all"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive14.name
  trigger_http          = true
  entry_point           = "getReviewAll"
}

resource "google_cloudfunctions_function_iam_binding" "binding14" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function14.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Delete Ingredient
resource "google_storage_bucket_object" "archive15" {
  provider = google-beta
  name   = "delete_ingredient.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./delete_ingredient/delete_ingredient.zip"
}

resource "google_cloudfunctions_function" "function15" {
  provider = google-beta
  name        = "function-delete-ingredient"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive15.name
  trigger_http          = true
  entry_point           = "deleteIngredient"
}

resource "google_cloudfunctions_function_iam_binding" "binding15" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function15.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Update Ingredient
resource "google_storage_bucket_object" "archive16" {
  provider = google-beta
  name   = "update_ingredient.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./update_ingredient/update_ingredient.zip"
}

resource "google_cloudfunctions_function" "function16" {
  provider = google-beta
  name        = "function-update-ingredient"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive16.name
  trigger_http          = true
  entry_point           = "updateIngredient"
}

resource "google_cloudfunctions_function_iam_binding" "binding16" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function16.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Get Ingredient
resource "google_storage_bucket_object" "archive17" {
  provider = google-beta
  name   = "get_ingredient.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./get_ingredient/get_ingredient.zip"
}

resource "google_cloudfunctions_function" "function17" {
  provider = google-beta
  name        = "function-get-ingredient"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive17.name
  trigger_http          = true
  entry_point           = "getIngredient"
}

resource "google_cloudfunctions_function_iam_binding" "binding17" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function17.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

### Get Ingredient All
resource "google_storage_bucket_object" "archive18" {
  provider = google-beta
  name   = "get_ingredient_all.zip"
  bucket = google_storage_bucket.bucket.name
  source = "./get_ingredient_all/get_ingredient_all.zip"
}

resource "google_cloudfunctions_function" "function18" {
  provider = google-beta
  name        = "function-get-ingredient-all"
  description = "My function"
  runtime     = "nodejs10"

  vpc_connector         = google_vpc_access_connector.connector.id
  available_memory_mb   = 128
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive18.name
  trigger_http          = true
  entry_point           = "getIngredientAll"
}

resource "google_cloudfunctions_function_iam_binding" "binding18" {
  provider = google-beta
  cloud_function = google_cloudfunctions_function.function18.name
  role = "roles/cloudfunctions.invoker"
  members = [
    "allUsers",
  ]
}

output "function_url" {
  value = google_cloudfunctions_function.function2.https_trigger_url
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