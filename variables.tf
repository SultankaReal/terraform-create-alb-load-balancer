variable "default_token" {
    default = "<your-token>" #yc iam create-token
}

variable "default_cloud_id" {
    default = "<your-cloud-id>"
}

variable "default_folder_id" {
  default = "<your-folder-id>"
}

variable "default_zone" {
  default = "ru-central1-b" #your default zone
}

variable "default_subnet_id_a" {
  default = "<your-subnet-in-zone-a>"
}

variable "default_subnet_id_b" {
  default = "<your-subnet-in-zone-b>"
}

variable "default_subnet_id_c" {
  default = "<your-subnet-in-zone-c>"
}

variable "default_sa_id" {
  default = "<your-service-account-id>"
}

variable "default_network_id" {
  default = "<your-network-id>"
}
