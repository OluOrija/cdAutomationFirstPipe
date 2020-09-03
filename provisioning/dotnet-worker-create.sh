#!/bin/bash
set -e
case "$CODEBUILD_WEBHOOK_TRIGGER" in
  *branch/master*)
      $(aws ecr get-login --no-include-email --region eu-west-1)
      docker build -t dotnet-build-worker -f ./provisioning/docker/Dotnet-Dockerfile ./provisioning/
      docker tag dotnet-build-worker:latest 350445798378.dkr.ecr.eu-west-1.amazonaws.com/dotnet-build-worker:latest
      docker push 350445798378.dkr.ecr.eu-west-1.amazonaws.com/dotnet-build-worker:latest
    ;;
esac