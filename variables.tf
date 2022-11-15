variable "function_name" {
  type = string
}

variable "iam_role_arn" {
  type = string
}

variable "source_dir" {
  type = string
}

variable "function_runtime" {
  type = string
}

variable "timeout" {
  type = string
}

variable "function_handler" {
  type = string
}

variable "environment_variables" {
  description = "A map that defines environment variables for the Lambda Function."
  type        = map(string)
  default     = {}
}

variable "vpc_subnet_ids" {
  description = "List of subnet ids when Lambda Function should run in the VPC. Usually private or intra subnets."
  type        = list(string)
  default     = null
}

variable "vpc_security_group_ids" {
  description = "List of security group ids when Lambda Function should run in the VPC."
  type        = list(string)
  default     = null
}
