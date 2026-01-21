terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "4.5.0"
    }
  }
}
provider "vault" {
  address             = "https://vault.awsdevops.sbs:8200/"
  skip_tls_verify     = true
  token               = var.vault_token
}