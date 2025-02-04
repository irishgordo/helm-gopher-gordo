terraform {
  required_providers {
    harvester = {
      source  = "harvester/harvester"
      version = "0.6.6"
    }
    ansible = {
      version = "1.3.0"
      source  = "ansible/ansible"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "5.0.0"
    }
  }
}

locals {
  codebase_root_path = abspath("${path.module}/..")
}

# !NOTE!: Please use the `/etc/rancher/rke2/rke2.yaml` (REMEMBER TO REPLACE LOCALHOST/LOOPBACK WITH YOUR HARVESTER VIP IPV4) from the main Harvester node for the provider.kubeconfig for Harvester
# using the Support -> Downloaded Kubeconfig "can" cause issues
provider "harvester" {
  # Configuration options
  kubeconfig = abspath("${local.codebase_root_path}/integration-cluster-kubeconfig.yaml")
}



provider "rancher2" {
  api_url    = var.api_url
  access_key = var.api_access_key
  secret_key = var.api_secret_key
  insecure   = true
}