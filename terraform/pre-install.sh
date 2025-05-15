#!/bin/bash

#install docker
sudo apt-get install docker.io  docker-compose-v2  -y
sudo chmod 777 /var/run/docker.sock
sudo usermod -aG docker $USER  && newgrp docker

#install jenkins

sudo apt-get update
sudo apt install fontconfig openjdk-21-jre -y

sudo wget -O /etc/apt/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo "deb [signed-by=/etc/apt/keyrings/jenkins-keyring.asc]" \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins

#install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
sudo apt install unzip
unzip awscliv2.zip
sudo ./aws/install

#Install kubectl (Master machine)
curl -o kubectl https://amazon-eks.s3.us-west-2.amazonaws.com/1.19.6/2021-01-05/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin
kubectl version --short --client

#Install eksctl (Master machine)
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin
eksctl version

#Install Trivy (Jenkins Master)
sudo apt-get install wget apt-transport-https gnupg lsb-release -y
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt-get update -y
sudo apt-get install trivy -y

#Install and configure SonarQube (Master machine)
docker run -itd --name SonarQube-Server -p 9000:9000 sonarqube:lts-community

#Create EKS Cluster (Master machine)
eksctl create cluster --name=wanderlust \
                    --region=us-east-2 \
                    --version=1.30 \
                    --without-nodegroup

#Associate IAM OIDC Provider (Master machine)
eksctl utils associate-iam-oidc-provider \
  --region us-east-2 \
  --cluster wanderlust \
  --approve

#Create Nodegroup (Master machine)
eksctl create nodegroup --cluster=wanderlust \
                     --region=us-east-2 \
                     --name=wanderlust \
                     --node-type=t2.large \
                     --nodes=2 \
                     --nodes-min=2 \
                     --nodes-max=2 \
                     --node-volume-size=29 \
                     --ssh-access \
                     --ssh-public-key=eks-nodegroup-key 




