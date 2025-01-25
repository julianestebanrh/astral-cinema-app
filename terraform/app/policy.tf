# policy.tf


# GitHub Actions Role
# Allows GitHub Actions to assume a role for deployment operations
resource "aws_iam_role" "github_actions_role" {
  name = "${var.app_name}-${var.environment}-github-actions-role" # Nombre dinámico con entorno
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "sts.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# GitHub Actions Upload Policy
# Defines permissions for GitHub Actions to upload to S3 and deploy Lambda
resource "aws_iam_policy" "github_actions_upload_policy" {
  name        = "${var.app_name}-${var.environment}-github-actions-upload-policy" # Nombre dinámico con entorno
  description = "Policy for GitHub Actions to upload to S3 and deploy Lambda for ${var.app_name}"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          # S3 related actions for static assets
          "s3:PutObject", "s3:GetObject", "s3:ListBucket"
        ],
        Resource = [
          "${aws_s3_bucket.static_assets.arn}", # Usamos el bucket dinámico
          "${aws_s3_bucket.static_assets.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          # Lambda related actions for deployment
          "lambda:UpdateFunctionCode", "lambda:CreateFunction",
          "lambda:PublishVersion", "lambda:UpdateFunctionConfiguration"
        ],
        Resource = "*"
      }
    ]
  })
}


# Attach GitHub Actions Policy to GitHub Actions Role
# Connects the policy with the role to grant deployment permissions
resource "aws_iam_role_policy_attachment" "attach_github_actions_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_upload_policy.arn
}

# ---------------------------------------------------------------------------------

resource "aws_iam_role" "lambda_execution_role" {
  name = "${var.app_name}-${var.environment}-lambda-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com" # Solo para Lambda
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "${var.app_name}-${var.environment}-lambda-execution-policy"
  description = "Policy for Lambda function"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
}
