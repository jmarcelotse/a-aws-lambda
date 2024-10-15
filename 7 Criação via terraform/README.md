Para implementar todo o processo descrito (testes da função Lambda, criação de gatilhos S3 e eventos programados via EventBridge Scheduler) usando **Terraform**, você precisará definir recursos como **função Lambda**, **bucket S3**, **eventos do S3**, **CloudWatch EventBridge Scheduler**, entre outros. Vamos detalhar a estrutura de arquivos e exemplos de código que podem ser utilizados para implementar tudo de forma automatizada.

# Estrutura de Arquivos Terraform
Uma boa prática é organizar seu código Terraform em múltiplos arquivos para melhor modularidade e manutenção. Aqui está uma sugestão de estrutura de diretórios:

bash
```
project/
│
├── main.tf                 # Definição dos recursos
├── variables.tf            # Definição de variáveis
├── outputs.tf              # Saídas para exibição
├── lambda/
│   ├── lambda_function.py  # Código da função Lambda
│   └── lambda.tf           # Definições Terraform da Lambda
├── s3/
│   └── s3.tf               # Definições do bucket S3 e gatilhos
└── scheduler/
    └── scheduler.tf        # Definições do EventBridge Scheduler
```
Agora, vamos detalhar cada um dos componentes em seus respectivos arquivos.

## 1. `providers.tf` - Configuração do Provider AWS
Esse arquivo define o provedor da AWS, permitindo ao Terraform se conectar à sua conta AWS:

hcl
```
provider "aws" {
  region = var.aws_region
}
```
## 2. `variables.tf` - Definição de Variáveis Globais
Aqui definimos as variáveis necessárias para o projeto, como a região da AWS e o nome dos recursos:

hcl
```
variable "aws_region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Nome da função Lambda"
  type        = string
  default     = "my_lambda_function"
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3"
  type        = string
  default     = "my-lambda-trigger-bucket"
}

variable "eventbridge_schedule_expression" {
  description = "Expressão CRON para o EventBridge Scheduler"
  type        = string
  default     = "rate(5 minutes)" # Executar a cada 5 minutos
}
```
## 3. `outputs.tf` - Outputs para Facilitar o Acesso
Aqui definimos os outputs que serão úteis ao final da execução do Terraform:

hcl
```
output "lambda_function_arn" {
  description = "ARN da função Lambda criada"
  value       = module.lambda_function.lambda_arn
}

output "s3_bucket_name" {
  description = "Nome do bucket S3 criado"
  value       = module.s3_bucket.bucket_name
}
```
## 4. main.tf - Arquivo Principal
O arquivo `main.tf` é o coração da infraestrutura, referenciando os módulos para criar os recursos:

hcl
```
module "lambda_function" {
  source              = "./modules/lambda_function"
  lambda_function_name = var.lambda_function_name
  s3_bucket_name      = var.s3_bucket_name
}

module "s3_bucket" {
  source        = "./modules/s3_bucket"
  s3_bucket_name = var.s3_bucket_name
}

resource "aws_cloudwatch_event_rule" "scheduled_event" {
  name        = "lambda_scheduled_event"
  description = "Aciona a função Lambda a cada 5 minutos"
  schedule_expression = var.eventbridge_schedule_expression
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule      = aws_cloudwatch_event_rule.scheduled_event.name
  arn       = module.lambda_function.lambda_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_event.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = module.s3_bucket.bucket_name

  lambda_function {
    lambda_function_arn = module.lambda_function.lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }
}
```

## 5. Módulo Lambda (`modules/lambda_function`)
O módulo Lambda encapsula a criação da função Lambda, sua role associada e as permissões necessárias.

modules/lambda_function/main.tf

hcl
```
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../../lambda"
  output_path = "${path.module}/../../lambda/lambda.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

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

resource "aws_iam_role_policy_attachment" "lambda_execution_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_lambda_function" "lambda_function" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.8"

  filename = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      S3_BUCKET = var.s3_bucket_name
    }
  }
}

output "lambda_arn" {
  value = aws_lambda_function.lambda_function.arn
}
```
modules/lambda_function/variables.tf

hcl
```
variable "lambda_function_name" {
  description = "Nome da função Lambda"
  type        = string
}

variable "s3_bucket_name" {
  description = "Nome do bucket S3"
  type        = string
}
```
## 6. Módulo S3 (modules/s3_bucket)
O módulo S3 encapsula a criação do bucket S3 e outras configurações necessárias.

modules/s3_bucket/main.tf

hcl
```
resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

output "bucket_name" {
  value = aws_s3_bucket.bucket.id
}
```

modules/s3_bucket/variables.tf

hcl
```
variable "s3_bucket_name" {
  description = "Nome do bucket S3"
  type        = string
}
```
## 7. Código da Função Lambda (`lambda/main.py`)
A função Lambda que será acionada tanto pelo cronograma do EventBridge Scheduler quanto pelos eventos de criação de objetos no S3. O código está em Python:

python
```
import json

def lambda_handler(event, context):
    print("Recebido o seguinte evento:")
    print(json.dumps(event))

    return {
        'statusCode': 200,
        'body': json.dumps('Evento processado com sucesso!')
    }
```
## 8. Gerenciamento de Dependências (`lambda/requirements.txt`)
Caso a função Lambda utilize pacotes externos, como boto3, você pode especificá-los aqui. No nosso exemplo, deixaremos vazio:

plaintext
```
# Aqui você pode listar pacotes como boto3, requests, etc.
```
# Conclusão
Essa estrutura permite que você crie um ambiente completo usando Terraform com Lambda, EventBridge Scheduler, gatilhos S3 e tudo automatizado. Para aplicar tudo isso no AWS, basta:

1. Navegar até o diretório do projeto.
2. Executar os comandos:

bash
```
terraform init
terraform apply
```
3. Após o apply, você verá os recursos sendo criados e o Lambda configurado para ser acionado por eventos S3 e EventBridge.

Essa solução cobre a criação de uma função Lambda que será invocada de três formas:

1. Manualmente pelo console da AWS.
2. Periodicamente usando uma expressão cron no EventBridge Scheduler.
3. Automática via eventos de criação de objetos no bucket S3.