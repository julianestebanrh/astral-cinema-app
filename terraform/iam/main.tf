resource "aws_iam_policy" "terraform_execution_policy" {
  name        = "${var.app_name}-${var.environment}-terraform-execution-policy" # Nombre dinámico con entorno
  description = "Policy for Terraform to manage AWS resources for ${var.app_name} deployment"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          # Permisos para S3
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject"
        ],
        Resource = [
          "arn:aws:s3:::${var.app_name}-${var.environment}-static-assets",  # Bucket de activos estáticos
          "arn:aws:s3:::${var.app_name}-${var.environment}-static-assets/*" # Objetos dentro del bucket
        ]
      },
      {
        Effect = "Allow",
        Action = [
          # Permisos para CloudFront
          "cloudfront:CreateDistribution",
          "cloudfront:GetDistribution",
          "cloudfront:UpdateDistribution",
          "cloudfront:CreateInvalidation"
        ],
        Resource = "*" # CloudFront no soporta ARNs específicos para distribuciones
      },
      {
        Effect = "Allow",
        Action = [
          # Permisos para Lambda
          "lambda:CreateFunction",
          "lambda:GetFunction",
          "lambda:UpdateFunctionCode",
          "lambda:UpdateFunctionConfiguration",
          "lambda:InvokeFunction"
        ],
        Resource = [
          # "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${var.app_name}-${var.environment}-*" 
          "arn:aws:lambda:${var.region}:${data.aws_caller_identity.current.account_id}:function:${var.app_name}-${var.environment}-ssr-function"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          # Permisos para API Gateway
          "apigateway:CreateApi",
          "apigateway:GetApi",
          "apigateway:UpdateApi",
          "apigateway:CreateStage",
          "apigateway:GetStage",
          "apigateway:UpdateStage",
          "apigateway:CreateIntegration",
          "apigateway:GetIntegration",
          "apigateway:UpdateIntegration",
          "apigateway:CreateRoute",
          "apigateway:GetRoute",
          "apigateway:UpdateRoute"
        ],
        Resource = [
          # "arn:aws:apigateway:${var.region}::/apis/*" # APIs específicas
          "arn:aws:apigateway:${var.region}::/apis/${var.app_name}-${var.environment}-ssr-api"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          # Permisos para CloudWatch Logs
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = [
          "arn:aws:logs:${var.region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/${var.app_name}-${var.environment}-ssr-function:*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          # Permisos misceláneos
          "tag:GetResources",
          "ec2:DescribeRegions"
        ],
        Resource = "*" # Estos permisos son necesarios para operaciones generales
      }
    ]
  })
}

resource "aws_iam_role" "terraform_execution_role" {
  name = "${var.app_name}-${var.environment}-terraform-execution-role" # Nombre dinámico con entorno
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "sts.amazonaws.com" # Solo para Terraform
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_terraform_policy" {
  role       = aws_iam_role.terraform_execution_role.name
  policy_arn = aws_iam_policy.terraform_execution_policy.arn
}

# Obtener el ID de la cuenta actual
data "aws_caller_identity" "current" {}

# Outputs
output "terraformrole_arn" {
  value = aws_iam_role.terraform_execution_role.arn
}
