import os

def lambda_handler(event, context):
    # Pegando a variável de ambiente MY_ENV_VARIABLE
    my_env_var = os.getenv('MY_ENV_VARIABLE', 'Nenhuma variável encontrada')

    return {
        'statusCode': 200,
        'body': f"A variável de ambiente é: {my_env_var}",
        'other_output': "Função Lambda executada com sucesso!!"
    }
