#!/bin/bash
sudo apt-get update -y
#########################################TAKING INPUTS###################################################

#read -p "Enter Your AWS ACCESS KEY: "  access_key
#read -p "Enter Your AWS SECRET ACCESS KEY: "  secret_access_key
#read -p "Enter AWS Region: "  region
#read -p "Enter Role ARN: " role_arn

SUBNET1=`grep subnet1 properties | cut -d "=" -f2`
SUBNET2=`grep subnet2 properties | cut -d "=" -f2`
SECURITY_GROUP=`grep security_Group properties | cut -d "=" -f2`
ROLE_ARN=`grep roleARN properties | cut -d "=" -f2`
CLUSTER_NAME=`grep cluster_Name properties | cut -d "=" -f2`

#########################################INSTALLING OF KUBECTL###########################################
cd ~
curl -o kubectl https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo cp ./kubectl /bin/kubectl && export PATH=/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
kubectl version --short --client

#########################################INSTALLATION OF AWS AUTHENTICATOR#################################

curl -o aws-iam-authenticator https://amazon-eks.s3-us-west-2.amazonaws.com/1.10.3/2018-07-26/bin/linux/amd64/aws-iam-authenticator
chmod +x ./aws-iam-authenticator
sudo cp ./aws-iam-authenticator /bin/aws-iam-authenticator && export PATH=/bin:$PATH
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
aws-iam-authenticator help

########################################INSTALLING AWS-CLI#################################################

#sudo apt-get install python-pip python-dev build-essential -y
#sudo pip install --upgrade pip
#sudo pip install --upgrade awscli
#pip install --upgrade --user awscli
#export PATH=/home/ec2-user/.local/bin:$PATH
#aws --version
cd ~/Terraform-Files/aws-terraform-eks
sudo terraform init
sudo terraform apply -input=false -auto-approve

#KUBECONFIG=$KUBECONFIG:~/.kube/config-$CLUSTER_NAME
#export KUBECONFIG
#echo 'export KUBECONFIG=$KUBECONFIG:~/.kube/config-$CLUSTER_NAME' >> ~/.bashrc

#kubectl get svc
