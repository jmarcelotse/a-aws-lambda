provider "aws" {
  region = "us-east-2" # Altere para a sua região desejada
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_logging" {
  name       = "lambda_logging_attachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  roles      = [aws_iam_role.lambda_exec.name]
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function_nodejs"
  handler       = "index.handler" # Nome do arquivo e função
  runtime       = "nodejs20.x"

  # Especifique o caminho do arquivo ZIP contendo o código da função
  filename = "lambda_function.zip" # O arquivo ZIP deve estar na mesma pasta que o main.tf

  role = aws_iam_role.lambda_exec.arn

  # Defina o timeout e outras opções padrão conforme necessário
  timeout = 3
}
