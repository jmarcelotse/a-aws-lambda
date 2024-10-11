module "lambda_function" {
  source               = "./modules/lambda_function"
  lambda_function_name = var.lambda_function_name
  s3_bucket_name       = var.s3_bucket_name
}

module "s3_bucket" {
  source         = "./modules/s3_bucket"
  s3_bucket_name = var.s3_bucket_name
}

resource "aws_cloudwatch_event_rule" "scheduled_event" {
  name                = "lambda_scheduled_event"
  description         = "Aciona a função Lambda a cada 5 minutos"
  schedule_expression = var.eventbridge_schedule_expression
}

resource "aws_cloudwatch_event_target" "invoke_lambda" {
  rule = aws_cloudwatch_event_rule.scheduled_event.name
  arn  = module.lambda_function.lambda_arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_lambda" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.scheduled_event.arn
}

resource "aws_lambda_permission" "allow_s3_to_invoke_lambda" {
  statement_id  = "AllowS3ToInvokeLambda"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_arn
  principal     = "s3.amazonaws.com"
  source_arn    = module.s3_bucket.bucket_arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = module.s3_bucket.bucket_name

  lambda_function {
    lambda_function_arn = module.lambda_function.lambda_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_s3_to_invoke_lambda]
}
