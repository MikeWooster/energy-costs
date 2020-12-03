# ---------------------------------------------------------------------------------------------------------------------
# TERRAFORM REMOTE STATE
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  backend "s3" {
    bucket  = "gsl-uat-terraform-state"
    key     = "mike/ecs-playground/terraform.tfstate"
    encrypt = "true"
    region  = "eu-west-1"
  }
}
