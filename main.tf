provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "image_bucket" {
  bucket = var.bucket_name
}

resource "aws_dynamodb_table" "image_metadata" {
  name = var.table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "ImageID"

attribute {
  name = "ImageID"
  type = "S"
}
}

// 1. Python dosyasını zip haline getir
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "lambda_function.py"
  output_path = "lambda_function_payload.zip"
}

// 2. Lambda Fonksiyonu
resource "aws_lambda_function" "s3_processor" {
  filename      = "lambda_function_payload.zip"
  function_name = "s3-image-metadata-extractor"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "lambda_function.lambda_handler" # DosyaAdı.FonksiyonAdı

  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.9"

  environment {
    variables = {
      DYNAMO_TABLE = var.table_name
    }
  }
}


# 1. S3'ün Lambda'yı çağırmasına izin ver (Permission)
resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.image_bucket.arn
}

# 2. S3 Bildirim Yapılandırması (Trigger)
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.image_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.s3_processor.arn
    events              = ["s3:ObjectCreated:*"] # Sadece yeni dosya yüklendiğinde
  }

  depends_on = [aws_lambda_permission.allow_s3] # Önce izin, sonra tetikleyici!
}