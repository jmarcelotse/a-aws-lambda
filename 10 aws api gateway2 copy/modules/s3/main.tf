resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.bucket

  versioning_configuration {
    status = var.versioning ? "Enabled" : "Suspended"
  }
}