Esse processo descrito envolve várias etapas de configuração no **AWS Lambda, CloudWatch**, **EventBridge Scheduler**, e **S3**, a fim de executar uma função Lambda automaticamente e acioná-la com base em eventos programados e eventos de adição de arquivos ao S3. Abaixo, vamos detalhar cada uma dessas etapas:

# 1. Executando a Função Lambda Manualmente

## Passo 1: Acessar a função no console AWS Lambda
- No console do **AWS Lambda**, você verá uma lista de funções Lambda. Selecione a função desejada ou crie uma nova se ainda não existir.

## Passo 2: Testando a Função Lambda
- Após selecionar sua função Lambda, clique no botão **“Test”** no painel superior.
- Será solicitado a criação de um evento de teste:
  - Dê um nome para o evento de teste (ex.: `TestEvent1`).
  - Defina um **JSON de entrada** que será passado para a função Lambda. Um exemplo básico pode ser algo como:

json
```
{
  "key1": "value1",
  "key2": "value2",
  "key3": "value3"
}
```
  - Salva o evento
  - Clique em “**Testar**” para executar a função com os parâmetros definidos no evento de teste.

## Passo 3: Alterando o Código da Função
- Modifique o código da função Lambda para que ele retorne o evento recebido de forma legível. Um exemplo de código simples em Python seria:

python
```
def lambda_handler(event, context):
    # Retorna o evento recebido para visualização
    return {
        'statusCode': 200,
        'body': event
    }
```
Esse código retorna o JSON do evento recebido como resposta.

## Passo 4: Deploy da Função
- Após fazer a alteração no código, clique no botão “**Deploy**” para disponibilizar a versão atualizada da função.
- Agora, você pode executar o teste novamente clicando em "**Test**" para verificar se o evento é retornado corretamente na saída da execução da função.

# 2. Configurando um Evento Cron no EventBridge Scheduler
## Passo 1: Criar uma Regra no CloudWatch
- Acesse o **console do CloudWatch** e vá até o menu “**Eventos > Regras**”.
- Clique em “**Criar regra**” para criar uma nova regra de acionamento de eventos.
- Dê um **nome** e uma **descrição** para a regra.

## Passo 2: Configurando a Programação do Evento
- Na seção de fonte do evento, selecione **Programação** para definir um cronograma de execução.
- Um botão chamado “**Continuar no EventBridge Scheduler**” vai aparecer. Clique nele para ser redirecionado à interface do **EventBridge Scheduler**.

## Passo 3: Configurando o Cronograma
- Na interface do **EventBridge**, selecione **Cronograma recorrente** e então a opção **Cronograma baseado em cron**.
- Defina o cronograma para o horário que desejar, por exemplo:
  - Para executar a cada dia à meia-noite:

bash
```
0 0 * * ? *
```
  - Para executar a cada 5 minutos:

bash
```
0/5 * * * ? *
```
- Clique em **Próximo** para continuar.

## Passo 4: Definindo o Destino como Lambda
- Na lista de destinos, selecione a opção AWS Lambda Invoke.
- Escolha a função Lambda criada ou a função que você configurou anteriormente.
- Na tela seguinte, defina o **JSON de entrada** que será enviado para a função Lambda, similar ao que foi utilizado no teste manual. Exemplo:

json
```
{
  "source": "eventbridge-scheduler",
  "action": "trigger",
  "message": "Scheduled Event Trigger"
}
```
- Finalize a criação do cronograma clicando em **Criar Cronograma**. Agora, sua função Lambda será acionada com base no cronograma definido.

# 3. Criando um Bucket S3 e Configurando o Gatilho Lambda
## Passo 1: Criar um Bucket no S3
- Acesse o console do S3 e clique em “Criar bucket”.
- Escolha um nome único para o bucket e selecione a região apropriada.
- Configure as opções de versão e controle de acesso de acordo com sua necessidade.
- Finalize a criação do bucket.

## Passo 2: Configurando o Gatilho no Lambda
- Volte ao console do AWS Lambda e acesse a função criada.
- No painel da função, clique em “Adicionar gatilho”.
- Selecione S3 como a origem do evento.
- Selecione o bucket recém-criado e defina o tipo de evento, como por exemplo, "S3: All object create events" (para acionar a função sempre que um novo objeto for - criado no bucket).
- Salve o gatilho. Agora, toda vez que um arquivo for adicionado ao bucket S3, a função Lambda será automaticamente executada.

# Conclusão
Esse fluxo mostra como configurar a execução de uma função Lambda em diferentes situações, seja com teste manual no console do Lambda, execução programada através do EventBridge Scheduler, ou através de eventos acionados por uploads no S3. Essas abordagens permitem acionar uma função Lambda de maneira controlada e automatizada.
