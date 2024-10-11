import json

def lambda_handler(event, context):
    print("Recebido o seguinte evento:")
    print(json.dumps(event))

    return {
        'statusCode': 200,
        'body': json.dumps('Evento processado com sucesso!')
    }
