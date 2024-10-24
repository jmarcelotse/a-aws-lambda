variable "aws_region" {
  description = "A região da AWS onde os recursos serão criados."
  type        = string
  default     = "us-east-2"
}

variable "bucket_name" {
  description = "Nome do bucket S3."
  type        = string
}

variable "lambda_name" {
  description = "Nome da função Lambda."
  type        = string
}

variable "ecr_repository_name" {
  description = "Nome do repositório ECR."
  type        = string
  default     = "lambda-swoole"
}
