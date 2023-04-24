resource "aws_iam_instance_profile" "profile_ssm" {
  name = "instance_profile_ssm"
  role = aws_iam_role.ssm-access.name
}