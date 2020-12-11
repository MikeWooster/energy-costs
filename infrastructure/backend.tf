# ---------------------------------------------------------------------------------------------------------------------
# TERRAFORM REMOTE STATE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket  = "gsl-uat-terraform-state"
    key     = "energycost/terraform.tfstate"
    encrypt = "true"
    region  = "eu-west-1"
  }
}
