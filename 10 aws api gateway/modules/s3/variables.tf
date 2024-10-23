variable "bucket_name" {
  description = "Nome do bucket no S3"
  type        = string
}

variable "region" {
  description = "Região do bucket no S3"
  type        = string
  default     = "us-east-2"
}

variable "versioning" {
  description = "Ativar ou desativar versionamento no bucket"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags para o bucket"
  type        = map(string)
  default     = {}
}
