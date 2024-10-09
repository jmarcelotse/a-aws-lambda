variable "function_name" {
  type        = string
  description = "Nome da função Lambda"
}

variable "lambda_role_name" {
  type        = string
  description = "Nome da Role para a Lambda"
}

variable "lambda_jar" {
  type        = string
  description = "Arquivo JAR contendo o código da função Lambda"
}

variable "timeout" {
  type        = number
  description = "Tempo limite para execução da função Lambda"
  default     = 10
}