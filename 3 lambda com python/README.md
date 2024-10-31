Para criar uma função Lambda utilizando Python via Terraform, você pode seguir um processo bastante simples. Python é uma das linguagens mais usadas com AWS Lambda devido à sua simplicidade e velocidade de desenvolvimento. Neste exemplo, vamos criar uma função Lambda básica em Python usando o Terraform, com a estrutura padrão para código Lambda em Python.

# Passo 1: Estrutura do Projeto
Aqui está uma estrutura simples de diretório que você pode usar:
```
my_lambda_function_python/
│
├── main.tf
├── lambda_function.py
└── lambda_function.zip (gerado pelo comando zip)
```
# Passo 2: Código da Função Lambda em Python
Crie um arquivo chamado `lambda_function.py` com o seguinte código Python:

python
```
def lambda_handler(event, context):
    # Evento e contexto da função Lambda
    print(f"Received event: {event}")
    return {
        'statusCode': 200,
        'body': 'Hello from Python Lambda!'
    }
```
Esse código simples retorna uma mensagem de sucesso com o código de status HTTP 200.

# Passo 3: Empacotar o Código Python
O AWS Lambda exige que você faça o upload de seu código em um formato compactado (ZIP). Para empacotar o código Python, você pode usar o seguinte comando:

bash
```
zip lambda_function.zip lambda_function.py
```
Isso criará um arquivo lambda_function.zip contendo o código da função Lambda.

# Passo 4: Arquivo Terraform (main.tf)
Agora, você precisa definir a função Lambda e as permissões necessárias no arquivo `main.tf`. Aqui está um exemplo de como fazer isso:

hcl
```
provider "aws" {
  region = "us-east-2" # Altere para a sua região
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

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

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function_python"
  handler       = "lambda_function.lambda_handler" # Nome do arquivo e função
  runtime       = "python3.9" # Altere para a versão do Python que você deseja usar

  # Especifique o caminho do arquivo ZIP contendo o código da função
  filename      = "lambda_function.zip"

  role          = aws_iam_role.lambda_exec.arn

  # Defina o timeout e outras opções conforme necessário
  timeout       = 3
}
```

# Explicação dos Componentes
- **aws_lambda_function**: Recurso que define a função Lambda.

  - **function_name**: Nome da função Lambda.
  - **handler**: O nome do arquivo Python e a função de entrada (formato arquivo.funcao).
  - **runtime**: Define o ambiente de execução como Python 3.9 (você pode alterar a versão conforme necessário).
  - **filename**: O caminho para o arquivo ZIP que contém o código da função Lambda.
  - **role**: A função IAM que a Lambda assume para executar.
- **aws_iam_role**: Cria a role IAM que concede à Lambda permissões para executar.
  - **assume_role_policy**: Permite que o serviço Lambda assuma a role.
- **aws_iam_policy_attachment**: Anexa a política de execução básica do AWS Lambda (permissões de logs) à role IAM.

# Passo 5: Executar o Terraform
1. **Inicialize o Terraform**:

Navegue até o diretório do projeto e execute o comando:

bash
```
terraform init
```
2. **Verifique o que será criado**:

Antes de aplicar as mudanças, você pode executar o comando:

bash
```
terraform plan
```
3. **Aplique as mudanças**:

Para criar a função Lambda, execute:

bash
```
terraform apply
```
# Conclusão
Com esses passos, você terá criado uma função Lambda em Python usando Terraform. O código cria uma simples função Lambda que responde com uma mensagem HTTP 200 e loga o evento recebido.