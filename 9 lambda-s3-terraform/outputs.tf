output "lambda_function_name" {
  description = "Nome da função Lambda"
  value       = aws_lambda_function.lambda.function_name
}

output "lambda_function_arn" {
  description = "ARN da função Lambda"
  value       = aws_lambda_function.lambda.arn
}

output "bucket_name" {
  description = "Nome do bucket S3"
  value       = aws_s3_bucket.lambda_trigger_bucket.bucket
}

output "ecr_repository_url" {
  description = "URL do repositório ECR"
  value       = aws_ecr_repository.lambda_swoole.repository_url
}
