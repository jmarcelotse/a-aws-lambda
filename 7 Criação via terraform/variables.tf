variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-2"
}

variable "lambda_function_name" {
  description = "Nome da função Lambda"
  type        = string
  default     = "my_lambda_function"
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3"
  type        = string
  default     = "my-lambda-trigger-bucket-s3"
}

variable "eventbridge_schedule_expression" {
  description = "Expressão CRON para o EventBridge Scheduler"
  type        = string
  default     = "rate(5 minutes)"
}
