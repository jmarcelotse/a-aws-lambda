output "lambda_function_arn" {
  description = "ARN da função Lambda criada"
  value       = module.lambda_function.lambda_arn
}

output "s3_bucket_name" {
  description = "Nome do bucket S3 criado"
  value       = module.s3_bucket.bucket_name
}
