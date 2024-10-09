resource "aws_iam_role" "lambda_exec" {
  name = var.lambda_role_name

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

resource "aws_lambda_function" "lambda_java" {
  function_name    = "my_java_lambda"
  handler          = "com.example.HelloWorld::handleRequest"
  runtime          = "java17" # Altere de "java20" para "java17" ou "java21"
  filename         = "./modules/lambda_java/HelloWorld.jar"
  role             = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("./modules/lambda_java/HelloWorld.jar")

  environment {
    # Variáveis de ambiente, se necessário
  }
}
