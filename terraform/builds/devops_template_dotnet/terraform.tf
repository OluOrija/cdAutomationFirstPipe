terraform {
  required_version = ">= 0.11.6"

  # Define Unique Key Only - All other vars are set in terraform.tfvars
  backend "s3" {
    bucket = "cd-deployment-terraform"
    key    = "sample.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

module "build" {
  # Include OpenSource Codebuild Module
  source = "../../modules/build"
  name   = "${var.build_name}"

  # Define VCS - Supports codecommit, github, github ent and bitbucket
  source_type     = "GITHUB"
  source_location = "${var.build_repo}"

  # Priv Mode - Allows container creation
  privileged_mode = false

  # Nothing to output initially
  artifact_type = "NO_ARTIFACTS"
  namespace     = "TE"
  stage         = "CD"
  build_timeout = "120"
  build_image   = "aws/codebuild/windows-base:2.0"
  build_compute_type = "BUILD_GENERAL1_MEDIUM"
  build_type = "WINDOWS_CONTAINER"
}

module "ecr" {
  source = "../../modules/ecr"
  create_ecr = "${var.create_ecr}"
  name   = "${var.build_name}"

  allowPullAccounts = [
    "350445798378", // DEV
  ]
}

# Add a webhook to bitbucket to allow for branch integration
resource "aws_codebuild_webhook" "GH-Webhook" {
  project_name  = "${module.build.project_name}"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type                    = "HEAD_REF"
      pattern                 = "refs/heads/master"
    }
  }

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_MERGED"
    }
  }
}
