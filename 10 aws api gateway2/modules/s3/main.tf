resource "aws_s3_bucket" "colecao_de_fotos" {
  bucket = var.bucket_name

  versioning {
    enabled = var.versioning
  }

  tags = var.tags
}

resource "aws_s3_bucket_server_side_encryption_configuration" "colecao_de_fotos_encryption" {
  bucket = aws_s3_bucket.colecao_de_fotos.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
