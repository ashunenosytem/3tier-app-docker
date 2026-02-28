module "ansible_vpc" {
  source = "./infra"

  project_name     = var.project_name
  vpc_cidr         = var.ansible_vpc_cidr
  instance_type    = var.instance_type
}
# resource "aws_s3_bucket" "tf_state" {
#   bucket = "my-terraform-ansible-state-bucket"
# }

# resource "aws_s3_bucket_versioning" "tf_state_versioning" {
#   bucket = aws_s3_bucket.tf_state.id

#   versioning_configuration {
#     status = "Enabled"
#   }
# }
