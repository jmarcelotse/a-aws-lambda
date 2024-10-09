Para criar uma função Lambda utilizando Terraform com a linguagem Java, você precisará seguir um processo semelhante ao do Node.js, mas com algumas diferenças relacionadas ao código e à estrutura do projeto. Neste exemplo, vamos criar uma função Lambda simples em Java.

# Passo 1: Estrutura do Projeto
Crie uma nova pasta para o seu projeto Java. Aqui está uma estrutura de diretórios simples:
```
my_lambda_function_java/
│
├── main.tf
├── lambda_function.jar
└── src/
    └── main/
        └── java/
            └── com/
                └── example/
                    └── LambdaFunctionHandler.java
```
# Passo 2: Código da Função Lambda
Crie o arquivo `LambdaFunctionHandler.java` no diretório `src/main/java/com/example/` com o seguinte conteúdo:

java
```
package com.example;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class LambdaFunctionHandler implements RequestHandler<String, String> {
    @Override
    public String handleRequest(String input, Context context) {
        context.getLogger().log("Input: " + input);
        return "Hello from Java Lambda! Input: " + input;
    }
}
```
# Passo 3: Empacotar o Código Java
Para que sua função Lambda funcione, você deve empacotar seu código Java em um arquivo JAR. Você pode fazer isso usando o Maven ou o Gradle. Aqui está um exemplo usando o Maven.

**Exemplo de pom.xml**

Se você estiver usando o Maven, crie um arquivo chamado `pom.xml` na raiz do projeto:

xml
```
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>my-lambda-function</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging>

    <dependencies>
        <dependency>
            <groupId>com.amazonaws</groupId>
            <artifactId>aws-lambda-java-core</artifactId>
            <version>1.2.1</version>
        </dependency>
    </dependencies>
</project>
```
Para empacotar seu código, execute o seguinte comando na raiz do seu projeto:

bash
```
mvn clean package
```
Isso criará o arquivo JAR em `target/my-lambda-function-1.0-SNAPSHOT.jar`.

# Passo 4: Criar o Arquivo Terraform
No arquivo `main.tf`, você irá definir a função Lambda. Aqui está um exemplo básico:

hcl
```
provider "aws" {
  region = "us-east-1" # Altere para a sua região desejada
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
  function_name = "my_lambda_function"
  handler       = "com.example.LambdaFunctionHandler::handleRequest" # Nome do pacote e método
  runtime       = "java17" # Altere para a versão desejada, 17 é a mais recente até o momento

  # Especifique o caminho do arquivo JAR contendo o código da função
  filename      = "target/my-lambda-function-1.0-SNAPSHOT.jar" # O arquivo JAR deve estar na pasta correta

  role          = aws_iam_role.lambda_exec.arn

  # Defina o timeout e outras opções padrão conforme necessário
  timeout       = 3
}
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
Agora você deve ter uma nova função Lambda em execução com a linguagem Java. Este exemplo utiliza configurações padrão e deve funcionar corretamente se o JAR estiver no caminho especificado.
