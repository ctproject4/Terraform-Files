KEY_NAME=`grep key_name properties | cut -d "=" -f2`
sed -i "s#Default: {key_name}#Default: $KEY_NAME#" sampletemplate.yaml

CLUSTER_NAME=`grep cluster_Name properties | cut -d "=" -f2`
sed -i "s#Default: {cluster_Name}#Default: $CLUSTER_NAME#" sampletemplate.yaml

SECURITY_GROUP=`grep security_Group properties | cut -d "=" -f2`
sed -i "s#Default: {security_Group}#Default: $SECURITY_GROUP#" sampletemplate.yaml

SUBNET1=`grep subnet1 properties | cut -d "=" -f2`
SUBNET2=`grep subnet2 properties | cut -d "=" -f2`
sed -i "s#Default: {subnets}#Default: $SUBNET1,$SUBNET2#" sampletemplate.yaml

AMI_ID=`grep worker_ami_id properties | cut -d "=" -f2`
sed -i "s#Default: {worker_ami_id}#Default: $AMI_ID#" sampletemplate.yaml

MIN_NODE=`grep min_nodes properties | cut -d "=" -f2`
sed -i "s#Default: {min_nodes}#Default: $MIN_NODE#" sampletemplate.yaml

MAX_NODE=`grep max_nodes properties | cut -d "=" -f2`
sed -i "s#Default: {max_nodes}#Default: $MAX_NODE#" sampletemplate.yaml

INSTANCE_TYPE=`grep instance_type properties | cut -d "=" -f2`
sed -i "s#Default: {instance_type}#Default: $INSTANCE_TYPE#" sampletemplate.yaml

VPC_ID=`grep vpc_id properties | cut -d "=" -f2`
sed -i "s#Default: {vpc_id}#Default: $VPC_ID#" sampletemplate.yaml

NODE_VOLUME_SIZE=`grep node_volume_size properties | cut -d "=" -f2`
sed -i "s#Default: {node_volume_size}#Default: $NODE_VOLUME_SIZE#" sampletemplate.yaml
