output "bucket_arn" {
  description = "ARN do bucket S3"
  value       = aws_s3_bucket.colecao_de_fotos.arn
}

output "bucket_name" {
  description = "Nome do bucket S3"
  value       = aws_s3_bucket.colecao_de_fotos.bucket
}
