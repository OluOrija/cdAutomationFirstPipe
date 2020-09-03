#!/bin/bash
set -e
case "$CODEBUILD_WEBHOOK_TRIGGER" in
  *branch/master*)
      cd terraform/builds/ecr && terraform init && terraform apply -no-color -auto-approve
      cd ../../
    ;;
esac
