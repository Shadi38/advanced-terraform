//for invoking the lumbda function in terminal without using apigateway, we should do below command:
//aws lambda invoke --region eu-west-2 --function-name hello response.json
//cat response.json
resource "aws_iam_role" "hello_lambda_exec" {
  name = "hello-lambda"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "hello_lambda_policy" {
  role       = aws_iam_role.hello_lambda_exec.name
  //The AWSLambdaBasicExecutionRole policy grants basic execution permissions for AWS Lambda, including:
  //Writing logs to Amazon CloudWatch.
  //Basic monitoring permissions.
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "hello" {
  function_name = "hello"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_hello.key

  runtime = "nodejs16.x"
  handler = "function.handler"
  //we need below line to redeploy the function if we change anything in the source code.architectures.architectures
  //ex: we change sth in code. if the hash of the zip archive is different,it will force to redeploy lambda 
  source_code_hash = data.archive_file.lambda_hello.output_base64sha256

  role = aws_iam_role.hello_lambda_exec.arn
}


resource "aws_cloudwatch_log_group" "hello" {
  name = "/aws/lambda/${aws_lambda_function.hello.function_name}"

  retention_in_days = 14
}


data "archive_file" "lambda_hello" {
  type = "zip"

  source_dir  = "../${path.module}/hello"
  output_path = "../${path.module}/hello.zip"
}


resource "aws_s3_object" "lambda_hello" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "hello.zip"
  source = data.archive_file.lambda_hello.output_path
  //below line calculates the MD5 checksum of the Lambda ZIP file.
  //If the ZIP file changes, Terraform detects the change via the MD5 hash and re-uploads the file to S3.
  etag = filemd5(data.archive_file.lambda_hello.output_path)
}