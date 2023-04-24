resource "aws_instance" "this" {
  ami                  = data.aws_ami.this.id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.profile_ssm.name
  user_data_base64     = filebase64("./files/startup.sh")
}