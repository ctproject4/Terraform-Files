#!/bin/bash
#sudo -i
sudo apt-get update -y
sudo apt-get install lxde -y
sudo start lxdm
sudo apt-get install xrdp -y

CLUSTER_NAME=`grep cluster_Name properties | cut -d "=" -f2`

KUBECONFIG=$KUBECONFIG:~/.kube/config-$CLUSTER_NAME
export KUBECONFIG
echo 'export KUBECONFIG=$KUBECONFIG:~/.kube/config-$CLUSTER_NAME' >> ~/.bashrc
kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml

cd /home/ubuntu
touch eks-admin-service-account.yaml
cat > /home/ubuntu/eks-admin-service-account.yaml <<EOL
apiVersion: v1
kind: ServiceAccount
metadata:
  name: eks-admin
  namespace: kube-system
EOL
kubectl apply -f /home/ubuntu/eks-admin-service-account.yaml

touch eks-admin-cluster-role-binding.yaml
cat > /home/ubuntu/eks-admin-cluster-role-binding.yaml <<EOL
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: eks-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: eks-admin
  namespace: kube-system
EOL
kubectl apply -f /home/ubuntu/eks-admin-cluster-role-binding.yaml

kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep eks-admin | awk '{print $1}')
#kubectl proxy
