# modules/iam/variables.tf

variable "app_name" {
  description = "Nombre de la aplicación"
  type        = string
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
}

variable "region" {
  description = "Región de AWS"
  type        = string
}

