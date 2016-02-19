resource "aws_iam_role" "master" {
  name = "k8s-master-${ var.name }"
  assume_role_policy = <<EOS
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": { "Service": "ec2.amazonaws.com" },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOS
}

resource "aws_iam_instance_profile" "master" {
  name = "k8s-master-${ var.name }"
  roles = [
    "${ aws_iam_role.master.name }"
  ]
}

resource "aws_iam_role_policy" "master" {
  name = "k8s-master-${ var.name }"
  role = "${ aws_iam_role.master.id }"
  policy = <<EOS
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:List*",
        "s3:Get*"
      ],
      "Resource": [ "arn:aws:s3:::${ var.bucket-prefix }/*" ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "elasticloadbalancing:*"
        ],
      "Resource": [ "*" ]
    }
  ]
}
EOS
}
