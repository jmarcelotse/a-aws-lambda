variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
}

resource "aws_s3_bucket" "lambda_trigger_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "Lambda Trigger S3 Bucket"
  }
}

output "bucket_name" {
  description = "Nome do bucket S3"
  value       = aws_s3_bucket.lambda_trigger_bucket.bucket
}
