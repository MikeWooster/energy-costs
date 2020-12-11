
variable "service" {
  type = string
  description = "The name of the service"
  default = "energycost"
}

variable "environment" {
  type = string
  description = "The environment we are running in"
  default = "prod"
}

variable "aws_region" {
  type = string
  description = "The region we will operate in."
  default = "eu-west-1"
}

variable "az" {
  type = list(string)
  description = "The availability zones present within the region."
  default = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}