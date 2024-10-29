output "policy_arn" {
  description = "ARN da política IAM"
  value       = aws_iam_policy.s3_access.arn
}
