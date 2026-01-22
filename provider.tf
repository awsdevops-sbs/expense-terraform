terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.5.0"
    }
  }
}
provider "http" {}

provider "vault" {
  address             = "https://vault.awsdevops.sbs:8200"
  token               = var.vault_token
  skip_tls_verify     = true
}