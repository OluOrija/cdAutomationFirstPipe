variable "allowPullAccounts" {
  type = "list"
  description = "The account numbers to allow pull access to the ECR"
}

variable "name" {
  type = "string"
  description = "The image name for the repository"
}
variable "create_ecr" {
  type = "string"
  default = "false"
  description = "Optionally create the repository"
}