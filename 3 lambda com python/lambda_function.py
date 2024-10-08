def lambda_handler(event, context):
    # Evento e contexto da função Lambda
    print(f"Received event: {event}")
    return {
        'statusCode': 200,
        'body': 'Hello from Python Lambda!'
    }
