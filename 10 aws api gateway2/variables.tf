variable "aws_region" {
  description = "Região da AWS"
  type        = string
  default     = "us-east-2"
}

variable "bucket_name" {
  description = "Nome do bucket S3"
  type        = string
  default     = "colecaodefotos-nxt"
}

variable "s3_versioning" {
  description = "Ativar ou desativar versionamento do S3"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags para os recursos"
  type        = map(string)
  default = {
    "Environment" = "dev"
    "Project"     = "Photo Collection API"
  }
}
