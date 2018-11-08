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

########################################CONFIGURING AWS DETAILS#############################################

#aws configure set aws_access_key_id 
#aws configure set aws_secret_access_key 
#aws configure set default.region us-east-1

#######################################CREATION OF CLUSTER##################################################

aws eks create-cluster --name $CLUSTER_NAME --role-arn $ROLE_ARN --resources-vpc-config subnetIds=$SUBNET1,$SUBNET2,securityGroupIds=$SECURITY_GROUP

sleep 13m

endpoint=$(aws eks describe-cluster --name $CLUSTER_NAME --query cluster.endpoint --output text)
certificate=$(aws eks describe-cluster --name $CLUSTER_NAME --query cluster.certificateAuthority.data --output text)

cd ~ && touch endpoint
echo $endpoint > endpoint
echo $certificate >> endpoint

mkdir -p ~/.kube
cd ~/.kube && touch config-$CLUSTER_NAME
cat >~/.kube/config-$CLUSTER_NAME <<EOL
apiVersion: v1
clusters:
- cluster:
    server: $endpoint
    certificate-authority-data: $certificate
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "$CLUSTER_NAME"
      #  - "-r"
      #  - "arn:aws:iam::715146130151:role/Devops_demo"
      # env:
        # - name: AWS_PROFILE
        #   value: "<aws-profile>"
EOL
KUBECONFIG=$KUBECONFIG:~/.kube/config-$CLUSTER_NAME
export KUBECONFIG
echo 'export KUBECONFIG=$KUBECONFIG:~/.kube/config-$CLUSTER_NAME' >> ~/.bashrc

kubectl get svc
