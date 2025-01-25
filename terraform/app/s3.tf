# s3.tf

# Bucket de S3 para almacenar archivos estáticos
resource "aws_s3_bucket" "static_assets" {
  bucket = "${var.app_name}-${var.environment}-static-assets" # Nombre dinámico con entorno

  tags = {
    Environment = var.environment
    Application = var.app_name
  }
}

# Bloque de acceso público para el bucket de S3
resource "aws_s3_bucket_public_access_block" "static_assets_access_block" {
  bucket = aws_s3_bucket.static_assets.id

  # Bloquear todo el acceso público
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configuración de CORS para el bucket de S3
resource "aws_s3_bucket_cors_configuration" "static_assets_cors" {
  bucket = aws_s3_bucket.static_assets.id

  cors_rule {
    allowed_headers = ["*"]                                                                              # Permitir todos los encabezados
    allowed_methods = ["GET", "HEAD"]                                                                    # Métodos permitidos
    allowed_origins = ["https://${aws_cloudfront_distribution.app_cloudfront_distribution.domain_name}"] # Orígenes permitidos
    max_age_seconds = 3000                                                                               # Tiempo de caché para preflight requests
  }
}
