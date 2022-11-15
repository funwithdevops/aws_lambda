###############################
# Function & Subscription
###############################
data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${var.function_name}.zip"
}

resource "aws_lambda_function" "function" {
  function_name    = var.function_name
  filename         = "${var.function_name}.zip"
  role             = var.iam_role_arn
  handler          = var.function_handler
  source_code_hash = data.archive_file.function_zip.output_base64sha256
  runtime          = var.function_runtime
  timeout          = var.timeout

  dynamic "environment" {
    for_each = length(keys(var.environment_variables)) == 0 ? [] : [true]
    content {
      variables = var.environment_variables
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_subnet_ids != null && var.vpc_security_group_ids != null ? [true] : []
    content {
      security_group_ids = var.vpc_security_group_ids
      subnet_ids         = var.vpc_subnet_ids
    }
  }
}

###############################
# Logging
###############################
resource "aws_cloudwatch_log_group" "function_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.function.function_name}"
  retention_in_days = 14
}

# !!! - It's unclear how the lambda function knows to log to the correct log group

###############################
# Module outputs
###############################

output "function_arn" {
  value = aws_lambda_function.function.arn
}

output "qualified_arn" {
  value = aws_lambda_function.function.qualified_arn
}
