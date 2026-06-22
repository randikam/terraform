provider "aws" {
  region = "ap-southeast-2"  # Specify your AWS region
}

# Create the Lambda layer
resource "aws_lambda_layer_version" "my_layer" {
  layer_name  = "my_lambda_layer"  # Name of your layer
  s3_bucket   = "bp-testing-s3bucket"   # S3 bucket where the layer ZIP is stored
  s3_key      = "python-3-9-layer1.zip"  # Path to the layer ZIP file in S3
  compatible_runtimes = ["python3.9"]  # Specify compatible runtimes

  # Optional: Description for the layer
  description = "A layer containing necessary libraries"
}

resource "aws_lambda_function" "my_lambda" {
  function_name = "lambda-dev-smoke-test"
  s3_bucket     = "bp-testing-s3bucket"             # S3 bucket where the function ZIP is stored
  s3_key        = "python-3-9-v1.zip"               # Path to the function ZIP file in S3
  handler       = "lambda_function.lambda_handler"  # Entry point of your Lambda function
  runtime       = "python3.9"                       # Adjust according to your runtime
  role          = aws_iam_role.lambda_exec.arn

  # Reference the layer
  layers        = [aws_lambda_layer_version.my_layer.arn]

  environment {
    variables = {
      key = "value"
    }
  }
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role-3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole",
        Effect    = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policy for Lambda permissions
resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
