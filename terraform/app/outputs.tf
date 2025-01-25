# outputs.tf

# ID de la distribución de CloudFront
output "cloudfront_distribution_id" {
  value       = aws_cloudfront_distribution.app_cloudfront_distribution.id
  description = "The ID of the CloudFront distribution"
}

# Nombre de dominio de CloudFront
output "cloudfront_domain_name" {
  value       = aws_cloudfront_distribution.app_cloudfront_distribution.domain_name
  description = "The domain name of the CloudFront distribution"
}

# ARN de la función Lambda
output "lambda_function_arn" {
  value       = aws_lambda_function.ssr_function.arn
  description = "The ARN of the Lambda function"
}

# Nombre del bucket de S3
output "s3_bucket_name" {
  value       = aws_s3_bucket.static_assets.bucket
  description = "The name of the S3 bucket for static assets"
}

# URL del API Gateway
output "api_gateway_url" {
  value       = aws_apigatewayv2_api.http_api.api_endpoint
  description = "The HTTP endpoint of the API Gateway"
}

output "terraformrole_arn" {
  value = aws_iam_role.github_actions_role.arn
}
