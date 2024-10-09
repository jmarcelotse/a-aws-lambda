Para criar uma nova função Lambda utilizando Terraform com a runtime Node.js 20.x, você precisa seguir alguns passos. Neste exemplo, vamos configurar uma função Lambda básica com as opções padrão.

Aqui está um guia passo a passo, incluindo um exemplo de código Terraform:

# Passo 1: Estrutura do Projeto
Crie uma nova pasta para o seu projeto e dentro dela, você pode criar os arquivos necessários. Aqui está uma estrutura de diretórios simples:
```
my_lambda_function/
│
├── main.tf
├── lambda_function.zip  (opcional, se você não quiser usar o código inline)
└── index.js
```
# Passo 2: Código da Função Lambda
Crie um arquivo chamado `index.js` que conterá o código da sua função Lambda. Aqui está um exemplo simples:

javascript
```
exports.handler = async (event) => {
    console.log("Event: ", JSON.stringify(event));
    return {
        statusCode: 200,
        body: JSON.stringify('Hello from Lambda!'),
    };
};
```
Se você optar por usar o código inline, não precisará do arquivo index.js, mas, para fins de exemplo, ele está incluído aqui.

# Passo 3: Criar o Arquivo Terraform
No arquivo main.tf, você irá definir a função Lambda. Aqui está um exemplo básico:

hcl
```
provider "aws" {
  region = "us-east-1" # Altere para a região desejada
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"
  handler       = "index.handler" # Nome do arquivo e função
  runtime       = "nodejs20.x"

  # Usando o código inline
  source_code_hash = filebase64sha256("lambda_function.zip") # Com a versão zip
  # Or, if using inline code:
  # source_code = <<EOF
  # exports.handler = async (event) => {
  #     console.log("Event: ", JSON.stringify(event));
  #     return {
  #         statusCode: 200,
  #         body: JSON.stringify('Hello from Lambda!'),
  #     };
  # };
  # EOF

  role = aws_iam_role.lambda_exec.arn

  # Defina o timeout e outras opções padrão conforme necessário
  timeout = 3
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
```
# Passo 4: Criar o arquivo ZIP (opcional)
Se você está usando o código de função no formato ZIP, deve criar um arquivo ZIP que contenha o arquivo `index.js.` Você pode fazer isso com o seguinte comando no terminal:

bash
```
zip lambda_function.zip index.js
```
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
Agora você deve ter uma nova função Lambda em execução com a runtime Node.js 20.x. Este exemplo utiliza configurações padrão e assume que você deseja usar a política básica de execução do Lambda. Você pode personalizar ainda mais a função Lambda adicionando triggers, variáveis de ambiente, e outras configurações conforme necessário.