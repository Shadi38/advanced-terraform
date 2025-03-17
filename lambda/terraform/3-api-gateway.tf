resource "aws_apigatewayv2_api" "main" {
  name          = "main"
  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_stage" "dev" {
  api_id = aws_apigatewayv2_api.main.id

  name        = "dev"
  auto_deploy = true
  
  //in below we can specify what attributes we want to collect and store in cloudWatch
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.main_api_gw.arn

    format = jsonencode({
      requestId               = "$context.requestId"
      sourceIp                = "$context.identity.sourceIp"
      requestTime             = "$context.requestTime"
      protocol                = "$context.protocol"
      httpMethod              = "$context.httpMethod"
      resourcePath            = "$context.resourcePath"
      routeKey                = "$context.routeKey"
      status                  = "$context.status"
      responseLength          = "$context.responseLength"
      integrationErrorMessage = "$context.integrationErrorMessage"
      }
    )
  }
}


resource "aws_cloudwatch_log_group" "main_api_gw" {
  name = "/aws/api-gw/${aws_apigatewayv2_api.main.name}"

  retention_in_days = 14
}


//for testing the http GET method we use below command in terminal:

//curl "https://rj7nqx5z9l.execute-api.eu-west-2.amazonaws.com/dev/hello?name=Anton"

//for testing the http POST method we use below command in terminal:

//curl -X POST -H "Content-Type: application/json" -d '{"name":"Ali"}' "https://rj7nqx5z9l.execute-api.eu-west-2.amazonaws.com/dev/hello"