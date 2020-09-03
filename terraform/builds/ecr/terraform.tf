terraform {
  required_version = ">= 0.11.6"

  # Define Unique Key Only - All other vars are set in terraform.tfvars
  backend "s3" {
    bucket  = "cd-deployment-terraform"
    key     = "container-repo.tfstate"
    region  = "eu-west-1"
  }
}

provider "aws" {
  region  = "eu-west-1"
}
###############################################################################################
############# DOTNET STUFF
resource "aws_ecr_repository" "dotnet-build-worker" {
  name = "cd-dotnet-build-worker"
}

resource "aws_ecr_repository" "devops-dotnet-build-worker" {
  name = "devops-dotnet-build-worker"
}

resource "aws_ecr_repository_policy" "dotnet-build-worker-ecr" {
  repository = "${aws_ecr_repository.dotnet-build-worker.name}"

  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "codebuild.amazonaws.com",
        "Effect": "Allow",
        "Principal": {
          "Service": "codebuild.amazonaws.com"
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
}

resource "aws_ecr_lifecycle_policy" "dotnet-build-worker-ecr" {
  repository = "${aws_ecr_repository.dotnet-build-worker.name}"

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 7 images",
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

resource "aws_ecr_repository_policy" "devops-dotnet-build-worker-ecr" {
  repository = "${aws_ecr_repository.devops-dotnet-build-worker.name}"

  policy = <<EOF
  {
    "Version": "2008-10-17",
    "Statement": [
      {
        "Sid": "codebuild.amazonaws.com",
        "Effect": "Allow",
        "Principal": {
          "Service": "codebuild.amazonaws.com"
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
}

resource "aws_ecr_lifecycle_policy" "devops-dotnet-build-worker-ecr" {
  repository = "${aws_ecr_repository.devops-dotnet-build-worker.name}"

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 7 images",
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
###############################################################################################
