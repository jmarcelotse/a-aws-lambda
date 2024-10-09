provider "aws" {
  region = "us-east-2"
}

# Função Lambda Python
module "lambda_python" {
  source           = "./modules/lambda_python"
  function_name    = "my_python_lambda"
  lambda_role_name = "lambda_exec_role_python"
  lambda_zip       = "${path.module}/modules/lambda_python/lambda_function.zip"
  timeout          = 3
}

# Função Lambda Node.js
module "lambda_nodejs" {
  source           = "./modules/lambda_nodejs"
  function_name    = "my_nodejs_lambda"
  lambda_role_name = "lambda_exec_role_nodejs"
  lambda_zip       = "${path.module}/modules/lambda_nodejs/lambda_function.zip"
  timeout          = 3
}

# Função Lambda Java
module "lambda_java" {
  source           = "./modules/lambda_java"
  function_name    = "my_java_lambda"
  lambda_role_name = "lambda_exec_role_java"
  lambda_jar       = "${path.module}/modules/lambda_java/HelloWorld.jar"
  timeout          = 10
}
