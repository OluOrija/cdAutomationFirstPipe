#!/bin/bash
CUR_VER=`curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version'` >/dev/null 2>&1
wget --quiet "https://releases.hashicorp.com/terraform/${CUR_VER}/terraform_${CUR_VER}_linux_amd64.zip" >/dev/null 2>&1
unzip -qq terraform_${CUR_VER}_linux_amd64.zip -d /usr/local/bin/ >/dev/null 2>&1
rm -rf terraform_${CUR_VER}_linux_amd64.zip >/dev/null 2>&1

wget --quiet "https://releases.hashicorp.com/packer/1.4.3/packer_1.4.3_linux_amd64.zip" >/dev/null 2>&1
unzip -qq packer_1.4.3_linux_amd64.zip -d /usr/local/bin/ >/dev/null 2>&1
rm -rf packer_1.4.3_linux_amd64.zip >/dev/null 2>&1

# Sending to Null to Quiet CB Output
apt-get install software-properties-common -qq -y >/dev/null 2>&1
add-apt-repository ppa:ansible/ansible-2.8 -y
apt-get update -qq -y >/dev/null 2>&1
apt-get install ansible -qq -y >/dev/null 2>&1
apt install python-pip python-dev libssl1.0-dev libffi-dev -y >/dev/null 2>&1
pip install setuptools --upgrade >/dev/null 2>&1
pip install "pywinrm>=0.3.0" >/dev/null 2>&1
pip install awscli >/dev/null 2>&1
pip install ansible-lint > /dev/null 2>&1
