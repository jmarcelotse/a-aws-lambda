provider "aws" {
  region = var.aws_region
}

module "s3" {
  source      = "./modules/s3"
  bucket_name = var.bucket_name
  region      = var.aws_region
  versioning  = var.s3_versioning
  tags        = var.tags
}

module "iam_policy" {
  source      = "./modules/iam-policy"
  policy_name = "colecaodefotos-S3-policy"
  bucket_arn  = module.s3.bucket_arn
}

module "iam_role" {
  source     = "./modules/iam-role"
  role_name  = "colecaodefotos-APIgateway-S3"
  policy_arn = module.iam_policy.policy_arn
}
