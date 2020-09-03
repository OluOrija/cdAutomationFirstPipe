#!/bin/bash
set -e
repo=$1
repo_name=`echo $1 | sed 's%^.*/\([^/]*\)\.git$%\1%g'`
cd terraform/builds/

if [ -z "$repo_name" ]; then
  echo "Undefined Repo" && exit 1
fi

case "$CODEBUILD_WEBHOOK_TRIGGER" in
  *pr*)
        if [ ! -z "$repo_name" ]; then
          cp -r devops_template_dotnet $repo_name
          sed -i  's/sample.tfstate/'${repo_name}'-worker.tfstate/' $repo_name/terraform.tf
          echo 'aws_region = "eu-west-1"
          build_name = "'$repo_name'"
          build_repo = "'$repo'"' > $repo_name/terraform.tfvars
          cd $repo_name && terraform init -no-color  >/dev/null && terraform plan -no-color
          cd ..
        fi
    ;;
  *branch/master*)
        if [ ! -z "$repo_name" ]; then
          cp -r devops_template_dotnet $repo_name
          sed -i  's/sample.tfstate/'${repo_name}'-worker.tfstate/' $repo_name/terraform.tf
          echo 'aws_region = "eu-west-1"
          build_name = "'$repo_name'"
          build_repo = "'$repo'"' > $repo_name/terraform.tfvars
          cd $repo_name && terraform init -no-color  >/dev/null && terraform apply -no-color -auto-approve
          cd ..
        fi
    ;;
esac
