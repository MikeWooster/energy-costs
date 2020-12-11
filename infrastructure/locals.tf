
locals {
  prefix = "mw-${var.environment}-${var.service}"
  common_tags = {
    CreatedBy = "Mike"
  }
}
