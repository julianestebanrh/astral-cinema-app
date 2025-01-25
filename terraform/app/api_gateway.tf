# api_gateway.tf

# API Gateway HTTP API
resource "aws_apigatewayv2_api" "http_api" {
  name          = "${var.app_name}-${var.environment}-http-api" # Nombre dinámico con entorno
  protocol_type = "HTTP"                                        # Tipo de protocolo (HTTP o WebSocket)
}



# Etapa de despliegue para el API Gateway
resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default" # Usamos "$default" como nombre de etapa
  auto_deploy = true       # Despliegue automático de cambios
}

# Integración del API Gateway con la función Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id           = aws_apigatewayv2_api.http_api.id
  integration_type = "AWS_PROXY"                                 # Tipo de integración (Lambda)
  integration_uri  = aws_lambda_function.ssr_function.invoke_arn # Usamos la función Lambda dinámica
}

# Ruta para manejar todas las solicitudes en el API Gateway
resource "aws_apigatewayv2_route" "default" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "ANY /{proxy+}" # Ruta comodín para todas las solicitudes
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}
