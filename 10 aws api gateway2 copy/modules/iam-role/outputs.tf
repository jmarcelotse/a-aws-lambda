output "role_arn" {
  description = "ARN da role IAM"
  value       = aws_iam_role.api_gateway_role.arn
}
