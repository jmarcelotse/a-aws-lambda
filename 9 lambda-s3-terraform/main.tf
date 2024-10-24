provider "aws" {
  region = var.aws_region
}

module "ecr_repository" {
  source = "./modules/ecr"

  ecr_repository_name = var.ecr_repository_name
}

module "s3_bucket" {
  source = "./modules/s3"

  bucket_name = var.bucket_name
}

module "lambda_function" {
  source = "./modules/lambda"

  lambda_name        = var.lambda_name
  ecr_repository_url = module.ecr_repository.repository_url
  s3_bucket_name     = module.s3_bucket.bucket_name
  aws_region         = var.aws_region
}
