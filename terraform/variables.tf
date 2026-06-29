variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "function_name" {
  type = string
}

variable "environment" {
  type    = string
  default = "staging"
}

variable "bucket_name" {
  type = string
}
