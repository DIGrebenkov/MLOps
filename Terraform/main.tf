terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone      = "ru-central1-d"
  token     = "---"                         # Удалено. Тут было значение моего токена.
  cloud_id  = "b1g6mghl9bb1p9j9g1ue"
  folder_id = "b1ghp93er44jptouahe3"
}

resource "yandex_iam_service_account" "sa" {
  name = "terraform-test"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
  folder_id = "b1ghp93er44jptouahe3"
  role = "storage.admin"
  member = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description = "static access key for object storage"
}


resource "yandex_storage_bucket" "my_bucket_249823750526302" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket = "test-bucket-name-something-12428460259384"
  folder_id = "b1ghp93er44jptouahe3"
}

