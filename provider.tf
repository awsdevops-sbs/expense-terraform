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
  address             = "http://vault.awsdevops16297.sbs:8200"
  token               = var.vault_token
  skip_tls_verify     = true
}