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