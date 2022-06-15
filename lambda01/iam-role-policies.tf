resource "aws_iam_policy" "iam_policy_enable_lambda_metrics" { 
    name         = "aws_iam_policy_enable_lambda_role_to_put_metrics"
    path         = "/"
    description  = "AWS IAM Policy for allowing lambda role to put metrics to CloudWatch"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Stmt1654785595997",
      "Action": "cloudwatch:*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
 