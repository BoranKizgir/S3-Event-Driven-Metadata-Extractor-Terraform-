// Lambda'nın AWS servisi olduğunu belirten 'Trusted Policy'
resource "aws_iam_role" "iam_for_lambda" {
  name = "s3_event_handler_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

// 2. S3 ve DynamoDB İzinlerini İçeren Policy
resource "aws_iam_policy" "lambda_logging_and_db" {
  name        = "lambda_logging_and_db"
  description = "S3 okuma ve DynamoDB yazma izni"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Action   = ["s3:GetObject"]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.image_bucket.arn}/*"
      },
      {
        Action   = ["dynamodb:PutItem"]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.image_metadata.arn
      }
    ]
  })
}

// 3. Rol ve Policy'yi Birbirine Bağlama (Attachment)
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging_and_db.arn
}