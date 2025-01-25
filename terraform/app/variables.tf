variable "app_name" {
  description = "Nombre de la aplicación"
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "El entorno debe ser 'dev', 'staging' o 'prod'."
  }
}

variable "region" {
  description = "Región de AWS"
  type        = string
}

variable "title_app" {
  description = "Título de la aplicación"
  type        = string
}

variable "cloudfront_secret_key" {
  description = "Secret key for CloudFront to access API Gateway"
  type        = string
  sensitive   = true
}

variable "lambda_memory_size" {
  description = "Tamaño de memoria para la función Lambda"
  type        = number
}

variable "lambda_timeout" {
  description = "Tiempo de espera para la función Lambda"
  type        = number
}

variable "terraform_execution_role_arn" {
  description = "ARN del rol de IAM para Terraform"
  type        = string
}
