import json

def lambda_handler(event, context):
    print("Event received from S3:")
    print(json.dumps(event))

    # Extrair informações do evento
    for record in event['Records']:
        s3_info = record['s3']
        bucket_name = s3_info['bucket']['name']
        object_key = s3_info['object']['key']

        print(f"Bucket: {bucket_name}")
        print(f"Object Key: {object_key}")

    return {
        'statusCode': 200,
        'body': json.dumps('Function executed successfully!')
    }
