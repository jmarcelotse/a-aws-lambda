def lambda_handler(event, context):
    print(f"Received event: {event}")
    return {
        'statusCode': 200,
        'body': 'Hello from Python Lambda!'
    }
