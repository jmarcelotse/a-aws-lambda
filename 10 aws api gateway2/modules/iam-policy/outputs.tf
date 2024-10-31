output "policy_arn" {
  description = "ARN da política IAM para acesso ao S3"
  value       = aws_iam_policy.s3_access_policy.arn
}