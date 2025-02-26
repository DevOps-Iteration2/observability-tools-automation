data "aws_ami" "ami" {
  most_recent = true
  owners      = ["973714476881"]
  name_regex  = "RHEL-9-DevOps-Practice"
}

data "aws_security_group" "sg" {
  name = "allow-all"
}