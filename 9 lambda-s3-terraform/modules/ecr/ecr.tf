variable "ecr_repository_name" {
  description = "Nome do repositório ECR"
  type        = string
}

resource "aws_ecr_repository" "lambda_swoole" {
  name = var.ecr_repository_name

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "Lambda Swoole ECR Repository"
  }
}

output "repository_url" {
  description = "URL do repositório ECR"
  value       = aws_ecr_repository.lambda_swoole.repository_url
}
