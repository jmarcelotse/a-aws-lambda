resource "aws_api_gateway_rest_api" "colecao_de_fotos" {
  name = "ColecaoDeFotosAPI"
  body = file("${path.module}/api_definicao.yaml")
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.colecao_de_fotos.id
}

resource "aws_api_gateway_stage" "prod" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.colecao_de_fotos.id
  deployment_id = aws_api_gateway_deployment.api_deployment.id

  lifecycle {
    ignore_changes = [deployment_id] # Ignora conflitos no estágio existente
  }
}
