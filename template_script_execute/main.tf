#main.tf
terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

# Call the resource defined in create_custom_rule.tf
  module "create_custom_rule" {
  source = "./create_custom_rule"
}
