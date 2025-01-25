# providers.tf

# Configuración del bloque de Terraform
terraform {
  required_version = "1.10.5" # Versión requerida de Terraform

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Proveedor AWS
      version = "5.84.0"        # Versión del proveedor AWS
    }
  }
}

# Configuración del proveedor AWS
provider "aws" {
  region = var.region # Región de AWS (definida en variables.tf)

  assume_role {
    role_arn = var.terraform_execution_role_arn # ARN del rol que creaste
  }

}
