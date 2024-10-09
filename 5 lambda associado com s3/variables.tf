variable "aws_region" {
  description = "Região AWS"
  default     = "us-east-2"
}

variable "bucket_name" {
  description = "Nome do bucket S3"
  default     = "nxtlambdas3"
}

variable "lambda_name" {
  description = "Nome da função Lambda"
  default     = "lambdas3"
}
