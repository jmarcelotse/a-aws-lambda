output "s3_bucket_arn" {
  description = "ARN do bucket S3"
  value       = module.s3.bucket_arn
}

output "iam_role_arn" {
  description = "ARN da role IAM"
  value       = module.iam_role.role_arn
}
