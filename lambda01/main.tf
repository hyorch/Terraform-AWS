provider "aws" {
  profile = "default"   # awscli default profile
  region = "eu-west-1"
}
 
data "archive_file" "zip_the_python_code" {
    type        = "zip"
    source_dir  = "${path.module}/python/"
    output_path = "${path.module}/python/python_code01.zip"
}
 
module "eventbridge" {
  source = "terraform-aws-modules/eventbridge/aws"

  create_bus = false

  rules = {
    demo_cron = {
      description         = "Trigger for a Lambda"
      schedule_expression = "rate(10 minutes)"
    }
  }

  targets = {
    demo_cron = [
      {
        name  = "lambda-demo-cron"       
        arn   = module.lambda.lambda_function_arn      
        input = jsonencode({"job": "cron-by-rate"})
      }
    ]
  }
}

module "lambda" {
  source  = "terraform-aws-modules/lambda/aws"
  
  function_name = "Lambda_Metrics"
  #handler       = "hello.lambda_handler"
  handler       = "function.lambda_handler"
  runtime       = "python3.9"

  create_package         = false
  local_existing_package = "${path.module}/python/python_code01.zip"

  role_name = "Lambda_Role"
  attach_policies = true
  number_of_policies = 1
  policies = [aws_iam_policy.iam_policy_enable_lambda_metrics.arn]

  create_current_version_allowed_triggers = false
  allowed_triggers = {
    ScanAmiRule = {
      principal  = "events.amazonaws.com"
      source_arn = module.eventbridge.eventbridge_rule_arns["demo_cron"]
    }
  }
}

