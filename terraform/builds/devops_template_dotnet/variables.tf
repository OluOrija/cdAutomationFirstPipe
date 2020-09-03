variable "aws_region" {
  type = "string"
}

variable "build_name" {
  type = "string"
}

variable "build_repo" {
  type = "string"
}

variable "create_ecr" {
  type = "string"
  default = "false"
}