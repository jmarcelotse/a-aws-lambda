provider "aws" {
  region = "us-east-2" # Altere para a sua região
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role_python"

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
  function_name = "my_lambda_function_python"
  handler       = "lambda_function.lambda_handler" # Nome do arquivo e função
  runtime       = "python3.9"                      # Altere para a versão do Python que você deseja usar

  # Especifique o caminho do arquivo ZIP contendo o código da função
  filename = "lambda_function.zip"

  role = aws_iam_role.lambda_exec.arn

  # Defina o timeout e outras opções conforme necessário
  timeout = 3
}
