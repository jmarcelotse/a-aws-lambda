provider "aws" {
  region = "us-east-2" # Altere para a sua região desejada
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role_java"

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
  function_name = "my_lambda_function_java"
  handler       = "com.example.LambdaFunctionHandler::handleRequest" # Nome do pacote e método
  runtime       = "java17"                                           # Altere para a versão desejada, 17 é a mais recente até o momento

  # Especifique o caminho do arquivo JAR contendo o código da função
  filename = "target/my-lambda-function-1.0-SNAPSHOT.jar" # O arquivo JAR deve estar na pasta correta

  role = aws_iam_role.lambda_exec.arn

  # Defina o timeout e outras opções padrão conforme necessário
  timeout = 3
}
