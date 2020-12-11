# ---------------------------------------------------------------------------------------------------------------------
# ECR
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecr_repository" "main" {
  name                 = "mikes-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }

  tags = merge(local.common_tags, {})
}
