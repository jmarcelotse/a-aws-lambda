Para realizar as etapas descritas no **AWS Lambda** e **CloudWatch**, vou detalhar o processo completo de como visualizar as métricas, logs, e fazer modificações no código para exibir informações que podem ser rastreadas via logs no **CloudWatch**.

# Passo a Passo:
## 1. Acesse a Aba "Monitor" no Console do AWS Lambda
- No **console da AWS Lambda**, acesse sua função Lambda.
- No painel principal da função, clique na aba **“Monitor”**.
  - Aqui você verá várias métricas como **invocações, erros, tempo de execução e throttles** (limitações) da função Lambda.
  - Essas métricas são geradas automaticamente pelo **AWS CloudWatch**.

## 2. Acesse os Logs da Função Lambda
- Ainda dentro da aba "**Monitor**", clique na sub-aba "**Logs**".
  - Aqui, o console exibe uma prévia das entradas de logs gerados pelas execuções recentes da sua função Lambda.

## 3. Visualize os Logs no CloudWatch
- Para acessar o **CloudWatch** diretamente e visualizar todos os logs detalhados:
  - Dentro da aba "**Logs**", clique no botão "**View CloudWatch logs**".
  - O console vai redirecioná-lo para o **CloudWatch**, exibindo o **log group** associado à função Lambda.
  - Dentro desse **log group**, você verá uma lista de **log streams**, que são criados automaticamente para cada execução da função Lambda.

## 4. Modificando o Código para Exibir Informações nos Logs
Agora, vamos modificar o código da função Lambda para que ele exiba uma mensagem personalizada no log. Isso é feito usando a função `print()` ou `logger` (se estiver usando uma linguagem como Python).

**Exemplo de código (Python) com log adicional**:

python
```
import json

def lambda_handler(event, context):
    # Exibir uma mensagem personalizada no log
    print("Execução da função Lambda iniciada.")
    print(f"Evento recebido: {json.dumps(event)}")

    # Retornar a resposta padrão
    return {
        'statusCode': 200,
        'body': json.dumps('Função executada com sucesso!')
    }
```

Para realizar as etapas descritas no AWS Lambda e CloudWatch, vou detalhar o processo completo de como visualizar as métricas, logs, e fazer modificações no código para exibir informações que podem ser rastreadas via logs no CloudWatch.

Passo a Passo:
1. Acesse a Aba "Monitor" no Console do AWS Lambda
No console da AWS Lambda, acesse sua função Lambda.
No painel principal da função, clique na aba “Monitor”.
Aqui você verá várias métricas como invocações, erros, tempo de execução e throttles (limitações) da função Lambda.
Essas métricas são geradas automaticamente pelo AWS CloudWatch.
2. Acesse os Logs da Função Lambda
Ainda dentro da aba "Monitor", clique na sub-aba "Logs".
Aqui, o console exibe uma prévia das entradas de logs gerados pelas execuções recentes da sua função Lambda.
3. Visualize os Logs no CloudWatch
Para acessar o CloudWatch diretamente e visualizar todos os logs detalhados:
Dentro da aba "Logs", clique no botão "View CloudWatch logs".
O console vai redirecioná-lo para o CloudWatch, exibindo o log group associado à função Lambda.
Dentro desse log group, você verá uma lista de log streams, que são criados automaticamente para cada execução da função Lambda.
4. Modificando o Código para Exibir Informações nos Logs
Agora, vamos modificar o código da função Lambda para que ele exiba uma mensagem personalizada no log. Isso é feito usando a função print() ou logger (se estiver usando uma linguagem como Python).

Exemplo de código (Python) com log adicional:
python
Copiar código
import json

def lambda_handler(event, context):
    # Exibir uma mensagem personalizada no log
    print("Execução da função Lambda iniciada.")
    print(f"Evento recebido: {json.dumps(event)}")

    # Retornar a resposta padrão
    return {
        'statusCode': 200,
        'body': json.dumps('Função executada com sucesso!')
    }
## Passo a Passo para Modificar o Código:
1. Acesse a função Lambda no console da AWS.
2. Na tela principal da função, edite o código no painel central (você pode usar o editor embutido ou fazer o upload do código modificado).
3. Adicione a instrução `print()` ou `logger` para exibir as mensagens desejadas no log (conforme o exemplo acima).
4. Depois de modificar o código, clique em "**Deploy**" para salvar e publicar as alterações.

## 5. Executando a Função e Verificando os Logs no CloudWatch
1. Execute a função manualmente clicando em “**Test**” no console da função Lambda, selecionando ou criando um evento de teste.
2. Após a execução, volte à aba “**Monitor**”.
3. Clique em "**Logs**" e depois em "**View CloudWatch logs**" para ver as novas entradas de log geradas pela função.
- No CloudWatch, localize o **log stream** correspondente à última execução da função.
- Dentro do log, você verá as mensagens que foram exibidas usando o comando `print()`.

## 6. Explorando a Aba "Configuração" no Console do Lambda
A aba "**Configuração**" no console da função Lambda contém várias opções importantes para gerenciamento da função. Vamos analisá-las:

### 6.1. Configuração Geral
- Aqui você pode ajustar as configurações principais da função Lambda:
  - **Nome**: O nome da função.
  - **Tempo de execução (timeout)**: Tempo máximo de execução permitido para a função antes de ser interrompida.
  - **Memória**: Quantidade de memória alocada para a função. O ajuste de memória também influencia diretamente o poder de processamento.
  - **Role de execução**: A role do IAM associada à função, que define as permissões da função Lambda para acessar outros serviços da AWS.

### 6.2. Gatilhos
- Esta seção lista os **gatilhos** (triggers) que podem invocar a função Lambda, como **S3**, **API Gateway**, **EventBridge**, entre outros.
  - Aqui, você pode adicionar, remover ou modificar gatilhos que disparam a execução da função automaticamente.
  - Por exemplo, se sua função é acionada por eventos S3 (como no caso de uploads de arquivos), você verá o bucket S3 listado aqui.

### 6.3. Destinos
- A opção “**Destinos**” permite configurar ações que ocorrem quando sua função Lambda é bem-sucedida ou falha.
  - Você pode definir destinos para sucesso e **falha da execução**, como enviar notificações para um tópico **SNS**, enviar mensagens para uma **SQS** ou invocar outra função Lambda.

### 6.4. Permissões
- Aqui você gerencia as permissões associadas à função Lambda:
  - Permissões que permitem que a função Lambda invoque outros serviços da AWS.
  - Você pode associar políticas de IAM ou visualizar as permissões já associadas à função.

### 6.5. Monitoramento e Metas de Métricas
- Nesta seção, você pode configurar **métricas** personalizadas ou ajustar o monitoramento existente da função, incluindo alertas por meio de **CloudWatch Alarms**.
  - Isso é útil para criar alertas baseados em falhas ou exceções recorrentes nas execuções da função.

# Recapitulando:
1. **Monitoramento**: Visualize as métricas e logs da função Lambda diretamente no console, e acesse o CloudWatch para explorar os logs em detalhes.
2. **Modificação do Código**: Adicione instruções `print()` para exibir informações nos logs e verifique as novas entradas no CloudWatch.
3. **Configuração**: Explore as diversas opções na aba "Configuração", incluindo gatilhos, destinos e permissões associadas à função Lambda.

Com isso, você consegue monitorar sua função Lambda de forma eficaz, fazer ajustes no código, e entender as diferentes opções de configuração disponíveis no console da AWS Lambda.
