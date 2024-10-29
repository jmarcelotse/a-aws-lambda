resource "aws_api_gateway_rest_api" "colecao_de_fotos" {
  name        = "ColecaoDeFotosAPI"
  description = "API para enviar imagens para o bucket colecaodefotos-leo"
  body        = file("${path.module}/api_definicao.yaml")
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.colecao_de_fotos.id
  stage_name  = "prod"
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.colecao_de_fotos.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id
}

output "api_invoke_url" {
  description = "URL para invocar a API"
  value       = "${aws_api_gateway_rest_api.colecao_de_fotos.execution_arn}/${aws_api_gateway_stage.prod.stage_name}/"
}
