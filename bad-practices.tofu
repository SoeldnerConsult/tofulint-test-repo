variable "db_password" {
  type    = string
  default = "SuperSecret123!"
}

# Resource with no description or tags
resource "aws_security_group" "no_tags" {
  name        = "no-tags-group"
  description = "Missing tags"
  vpc_id      = "vpc-123456"
}

# Unused local variable
locals {
  unused_value = "I am not used"
}


