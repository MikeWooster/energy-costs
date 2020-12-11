

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