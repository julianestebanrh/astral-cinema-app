# lambda.tf

# Archivo ZIP para el código de la función Lambda
data "archive_file" "lambda_code" {
  type        = "zip"
  source_dir  = "${path.module}/../../.output/server" # Directorio con el código de la aplicación
  output_path = "${path.module}/lambda-server.zip"    # Archivo ZIP resultante
}

# Función Lambda para SSR (Server-Side Rendering)
resource "aws_lambda_function" "ssr_function" {
  filename      = data.archive_file.lambda_code.output_path
  function_name = "${var.app_name}-${var.environment}-ssr-function" # Nombre dinámico con entorno
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = "index.handler"        # Punto de entrada de la función
  runtime       = "nodejs20.x"           # Entorno de ejecución
  memory_size   = var.lambda_memory_size # Memoria asignada
  timeout       = var.lambda_timeout     # Tiempo de espera en segundos

  # Variables de entorno para la función Lambda
  environment {
    variables = {
      NODE_ENV = var.environment # Entorno de ejecución
    }
  }

  # Etiquetas para identificar el entorno
  tags = {
    Environment = var.environment
    Application = var.app_name
  }
}
