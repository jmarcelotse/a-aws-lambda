output "s3_bucket_arn" {
  description = "ARN do bucket S3"
  value       = module.s3.bucket_arn
}

output "iam_role_arn" {
  description = "ARN da role IAM"
  value       = module.iam_role.role_arn
}

output "api_invoke_url" {
  description = "URL para invocar a API"
  value       = "${aws_api_gateway_rest_api.colecao_de_fotos.execution_arn}/${aws_api_gateway_stage.prod.stage_name}/"
}
