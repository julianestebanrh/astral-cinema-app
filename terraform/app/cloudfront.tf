# cloudfront.tf

# Identidad de acceso para CloudFront
resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "Origin Access Identity for ${var.title_app}"
}

# Distribución de CloudFront
resource "aws_cloudfront_distribution" "app_cloudfront_distribution" {
  enabled = true # Habilitar la distribución

  # Origen para el API Gateway (SSR)
  origin {
    domain_name = "${aws_apigatewayv2_api.http_api.id}.execute-api.${var.region}.amazonaws.com" # Usamos el API Gateway dinámico
    origin_id   = "SSRApi"

    # Agregar el encabezado personalizado
    custom_header {
      name  = "x-cloudfront-secret"
      value = var.cloudfront_secret_key
    }

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only" # Solo HTTPS
      origin_ssl_protocols   = ["TLSv1.2"]  # Protocolos SSL permitidos
    }
  }

  # Origen para los archivos estáticos en S3
  origin {
    domain_name = aws_s3_bucket.static_assets.bucket_regional_domain_name # Usamos el bucket S3 dinámico
    origin_id   = "StaticAssets"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }

  # Comportamiento de caché predeterminado para SSR
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    target_origin_id       = "SSRApi"
    viewer_protocol_policy = "redirect-to-https" # Redirigir a HTTPS

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
    }
  }

  # Comportamiento de caché para archivos estáticos
  ordered_cache_behavior {
    path_pattern     = "/static/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = "StaticAssets"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400    # 24 horas
    max_ttl                = 31536000 # 1 año
  }

  # Certificado SSL predeterminado de CloudFront
  viewer_certificate {
    cloudfront_default_certificate = true
  }

  # Sin restricciones geográficas
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Etiquetas para identificar el entorno
  tags = {
    Environment = var.environment
    Application = var.app_name
  }
}
