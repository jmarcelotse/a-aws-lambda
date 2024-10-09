provider "aws" {
  region = var.aws_region
}

# Criar bucket S3
resource "aws_s3_bucket" "lambda_trigger_bucket" {
  bucket = var.bucket_name
}

# Configurar criptografia no bucket usando o recurso apropriado
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.lambda_trigger_bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Configurar versionamento de bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.lambda_trigger_bucket.bucket
  versioning_configuration {
    status = "Suspended"
  }
}

# Bloquear acesso público ao bucket S3
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket                  = aws_s3_bucket.lambda_trigger_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Subir o arquivo ZIP da Lambda para o bucket S3
resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_trigger_bucket.bucket
  key    = "lambda.zip" # Nome do arquivo no bucket S3
  source = "lambda.zip" # Caminho local para o arquivo lambda.zip
}

# Criar função Lambda
resource "aws_lambda_function" "primeira_funcao" {
  function_name = var.lambda_name
  runtime       = "python3.8"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = "lambda_function.lambda_handler"

  # Usando o arquivo ZIP carregado no bucket S3
  s3_bucket = aws_s3_bucket.lambda_trigger_bucket.bucket
  s3_key    = aws_s3_object.lambda_zip.key

  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.lambda_trigger_bucket.bucket
    }
  }
}

# Permitir que o S3 invoque a função Lambda
resource "aws_lambda_permission" "allow_s3_to_invoke" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.primeira_funcao.function_name
  principal     = "s3.amazonaws.com"

  source_arn = aws_s3_bucket.lambda_trigger_bucket.arn
}

# Configurar notificação S3 para Lambda
resource "aws_s3_bucket_notification" "s3_to_lambda" {
  bucket = aws_s3_bucket.lambda_trigger_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.primeira_funcao.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_to_invoke]
}
