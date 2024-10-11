resource "aws_s3_bucket" "bucket" {
  bucket = var.s3_bucket_name

  versioning {
    enabled = true
  }
}

# Definindo a criptografia com o novo recurso sugerido
resource "aws_s3_bucket_server_side_encryption_configuration" "sse" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
