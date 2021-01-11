#EC2用のiam_role
resource "aws_iam_role" "ec2_role" {
  name = "ec2-role-khabib"
  path = "/"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

#iam_roleをEC2へ紐付け
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"

  role = aws_iam_role.ec2_role.name
}