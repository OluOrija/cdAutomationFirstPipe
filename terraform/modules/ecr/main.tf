resource "aws_ecr_repository" "default" {
  count = "${var.create_ecr == "true" ? 1 : 0}"
  name  = "te-${var.name}"
}

data template_file "ecr_repository_policy_template" {
  template = <<EOF
  {
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "AllowPullFromOtherAccounts",
      "Effect": "Allow",
      "Principal": {
        "AWS": [$${ALLOW_PULL_ACCOUNTS}]
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ]
    },
    {
      "Sid": "AllowPushPullForCodeBuild",
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:GetDownloadUrlForLayer",
        "ecr:InitiateLayerUpload",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ]
    },
    {
      "Sid": "AllowPullForCodePipeline",
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer"
      ]
    }
  ]
}
EOF

  vars = {
    ALLOW_PULL_ACCOUNTS = "${join(",", formatlist("\"arn:aws:iam::%s:root\"", var.allowPullAccounts))}"
  }
}

resource "aws_ecr_repository_policy" "default" {
  count = "${var.create_ecr == "true" ? 1 : 0}"
  repository = "${aws_ecr_repository.default[count.index]}"

  policy = "${data.template_file.ecr_repository_policy_template.rendered}"
}

resource "aws_ecr_lifecycle_policy" "default" {
  count = "${var.create_ecr == "true" ? 1 : 0}"
  repository = "${aws_ecr_repository.default[count.index]}"

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 7 untagged (previously latest) images",
            "selection": {
                "tagStatus": "untagged",
                "countType": "imageCountMoreThan",
                "countNumber": 7
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
