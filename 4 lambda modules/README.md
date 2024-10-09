Para organizar e reutilizar os recursos que criamos anteriormente (funções Lambda com diferentes runtimes: Node.js, Java, Python), o ideal é modularizar o código Terraform. Com módulos, você pode encapsular a lógica de cada recurso, facilitando o uso e a manutenção. A seguir, vou mostrar como criar um módulo para cada função Lambda separadamente (Node.js, Java, e Python) e como reutilizar esses módulos no arquivo main.tf.

# Estrutura do Projeto
Aqui está a estrutura recomendada para modularizar as funções Lambda:
```
my_terraform_project/
│
├── main.tf
├── modules/
│   ├── lambda_python/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── lambda_function.py
│   │   └── lambda_function.zip (gerado pelo comando zip)
│   ├── lambda_nodejs/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── index.js
│   │   └── lambda_function.zip (gerado pelo comando zip)
│   ├── lambda_java/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── HelloWorld.jar
```
# Módulo para Função Lambda em Python
Dentro do diretório `modules/lambda_python`, crie os seguintes arquivos:

main.tf (Lambda Python)

hcl
```
resource "aws_iam_role" "lambda_exec" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
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

resource "aws_lambda_function" "lambda_python" {
  function_name = var.function_name
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  filename      = var.lambda_zip
  role          = aws_iam_role.lambda_exec.arn
  timeout       = var.timeout
}
```
variables.tf (Lambda Python)

hcl
```
variable "function_name" {
  type        = string
  description = "Nome da função Lambda"
}

variable "lambda_role_name" {
  type        = string
  description = "Nome da Role para a Lambda"
}

variable "lambda_zip" {
  type        = string
  description = "Arquivo ZIP contendo o código da função Lambda"
}

variable "timeout" {
  type        = number
  description = "Tempo limite para execução da função Lambda"
  default     = 3
}
```
outputs.tf (Lambda Python)

hcl
```
output "lambda_function_name" {
  value = aws_lambda_function.lambda_python.function_name
}
```
## Código da Função Python (`lambda_function.py`)
Esse arquivo vai conter o código que será usado na Lambda.

python
```
def lambda_handler(event, context):
    print(f"Received event: {event}")
    return {
        'statusCode': 200,
        'body': 'Hello from Python Lambda!'
    }
```
Crie um arquivo ZIP com o código Python usando o comando:

bash
```
zip lambda_function.zip lambda_function.py
```
# Módulo para Função Lambda em Node.js
Dentro do diretório `modules/lambda_nodejs`, crie os seguintes arquivos:

main.tf (Lambda Node.js)

hcl
```resource "aws_iam_role" "lambda_exec" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
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

resource "aws_lambda_function" "lambda_nodejs" {
  function_name = var.function_name
  handler       = "index.handler"
  runtime       = "nodejs20.x"
  filename      = var.lambda_zip
  role          = aws_iam_role.lambda_exec.arn
  timeout       = var.timeout
}
```
variables.tf (Lambda Node.js)

hcl
```
variable "function_name" {
  type        = string
  description = "Nome da função Lambda"
}

variable "lambda_role_name" {
  type        = string
  description = "Nome da Role para a Lambda"
}

variable "lambda_zip" {
  type        = string
  description = "Arquivo ZIP contendo o código da função Lambda"
}

variable "timeout" {
  type        = number
  description = "Tempo limite para execução da função Lambda"
  default     = 3
}
```
outputs.tf (Lambda Node.js)

hcl
```
output "lambda_function_name" {
  value = aws_lambda_function.lambda_nodejs.function_name
}
```
## Código da Função Node.js (`index.js`)
Esse arquivo vai conter o código que será usado na Lambda.

javascript
```
exports.handler = async (event) => {
    console.log("Received event:", event);
    const response = {
        statusCode: 200,
        body: JSON.stringify('Hello from Node.js Lambda!'),
    };
    return response;
};
```
Crie um arquivo ZIP com o código Node.js usando o comando:

bash
```
zip lambda_function.zip index.js
```

# Módulo para Função Lambda em Java
Dentro do diretório `modules/lambda_java`, crie os seguintes arquivos:

main.tf (Lambda Java)

hcl
```
resource "aws_iam_role" "lambda_exec" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
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
  function_name = var.function_name
  handler       = "com.example.HelloWorld::handleRequest"
  runtime       = "java11"
  filename      = var.lambda_jar
  role          = aws_iam_role.lambda_exec.arn
  timeout       = var.timeout
}
```
variables.tf (Lambda Java)

hcl
```
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
```
outputs.tf (Lambda Java)
hcl
Copiar código
output "lambda_function_name" {
  value = aws_lambda_function.lambda_java.function_name
}

outputs.tf (Lambda Java)

hcl
```
output "lambda_function_name" {
  value = aws_lambda_function.lambda_java.function_name
}
```

## Código da Função Java (`HelloWorld.java`)
Compile seu código Java em um arquivo JAR e coloque-o no diretório `lambda_java`. Exemplo de código simples em Java:

java
```
package com.example;

public class HelloWorld {
    public String handleRequest(Map<String, String> event, Context context) {
        return "Hello from Java Lambda!";
    }
}
```
Após compilar, crie um arquivo `HelloWorld.jar` com seu código.

# Usando os Módulos no Arquivo Principal
Agora, no seu arquivo `main.tf` na raiz do projeto, você pode chamar esses módulos.

hcl
```
provider "aws" {
  region = "us-east-1"
}

# Função Lambda Python
module "lambda_python" {
  source         = "./modules/lambda_python"
  function_name  = "my_python_lambda"
  lambda_role_name = "lambda_exec_role_python"
  lambda_zip     = "${path.module}/modules/lambda_python/lambda_function.zip"
  timeout        = 3
}

# Função Lambda Node.js
module "lambda_nodejs" {
  source         = "./modules/lambda_nodejs"
  function_name  = "my_nodejs_lambda"
  lambda_role_name = "lambda_exec_role_nodejs"
  lambda_zip     = "${path.module}/modules/lambda_nodejs/lambda_function.zip"
  timeout        = 3
}

# Função Lambda Java
module "lambda_java" {
  source         = "./modules/lambda_java"
  function_name  = "my_java_lambda"
  lambda_role_name = "lambda_exec_role_java"
  lambda_jar     = "${path.module}/modules/lambda_java/HelloWorld.jar"
  timeout        = 10
}
```
########
Para invocar as três funções Lambda que você criou (Java, Node.js e Python), você pode usar o comando `aws lambda invoke` para cada função, especificando o nome da função e o arquivo de saída para o resultado.

# Passos para Invocar as Funções Lambda:
1. **Obtenha o Nome das Funções Lambda Criadas**

- Você pode verificar os nomes das funções Lambda no painel do AWS Management Console (se foram criadas corretamente) ou usando o comando terraform output, caso tenha configurado um output para os nomes das funções no seu código Terraform.
Comando para Invocar as Funções

O comando geral é:

bash
```
aws lambda invoke --function-name <function_name> <output_file>
```
1. Invocando a Função Java:
bash
```
aws lambda invoke --function-name lambda_java_function output_java.txt
```
2. Invocando a Função Node.js:
bash
```
aws lambda invoke --function-name lambda_nodejs_function output_nodejs.txt
```
3. Invocando a Função Python:
bash
```
aws lambda invoke --function-name lambda_python_function output_python.txt
```