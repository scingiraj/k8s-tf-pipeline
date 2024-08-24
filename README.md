# EKS Provision with Terraform

This repository contains Infrastructure as Code (IaC) for setting up a production-ready EKS cluster in multiple environments, using Terraform.

## Modules

The codebase is organized into several modules, each serving a specific purpose:

1. **EKS:** This module deploys an Amazon Elastic Kubernetes Service (EKS) cluster in your AWS environment. It provides a managed Kubernetes platform, eliminating the need to set up, operate, and maintain your own Kubernetes control plane or worker nodes.

2. **VPC:** This module sets up a Virtual Private Cloud (VPC) in your AWS environment. It provides an isolated, virtual network where you can launch AWS resources in a network that you define.

## Prerequisites

Before using the code in this repository, make sure you have the following:

- An AWS account
- Terraform installed on your local machine
- AWS CLI configured with appropriate permissions

### Create Key Pair for EC2 Instances (Optional)
```
aws ec2 create-key-pair --key-name terraform_non_prod_keypair
# copy key from output to ~/.ssh/terraform_non_prod_keypair.pem
```


## Usage

To deploy your infrastructure, follow these steps:

1. Clone this repository: `git clone https://github.com/your-github-username/k8s-tf-pipeline.git`
2. Navigate to the project directory: `cd k8s-tf-pipeline`
3. Initialize your Terraform workspace: `terraform init`
4. Create a new workspace (if required): `terraform workspace new <workspace_name>`
5. Plan your changes: `terraform plan -var-file=variables/env.tfvars`
6. Apply your changes: `terraform apply -var-file=variables/env.tfvars`

Configure the Load Balancer on our EKS because our application will have an ingress controller.
Download the policy for the LoadBalancer prerequisite.
```
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json
```
Create the IAM policy using the below command
```
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json
```
Create OIDC Provider
```
eksctl utils associate-iam-oidc-provider --region=eu-west-3 --cluster=demo-cluster --approve
```
Create a Service Account by using below command and replace your account ID with your one
```
eksctl create iamserviceaccount --cluster=demo-cluster --namespace=kube-system --name=aws-load-balancer-controller --role-name AmazonEKSLoadBalancerControllerRole --attach-policy-arn=arn:aws:iam::<your_account_id>:policy/AWSLoadBalancerControllerIAMPolicy --approve --region=eu-west-3
```
Run the below command to deploy the AWS Load Balancer Controller
```
sudo snap install helm --classic
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks
helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=my-cluster --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller
```
```
kubectl get deployment -n kube-system aws-load-balancer-controller
```
## Network Policies -- Installing Calico on Amazon EKS
Apply the Calico manifests
```
kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/master/calico-operator.yaml
kubectl apply -f https://raw.githubusercontent.com/aws/amazon-vpc-cni-k8s/master/config/master/calico-crs.yaml
```
Watch the calico-system DaemonSets
```
kubectl get daemonset calico-node -n calico-system
```
Default network polices are placed in folder - **default-network-policies** , review and reuse it as per the use case.

## hpa
Kubernetes-native tools such as vpa/hpa can be used to dynamically scale resources based on real-time metrics such as CPU and memory, to scale based on network usage or any other parameters, you need to configure KEDA or Prometheus. Sample manifests can referenced from hpa folder.

## Install Proemetheus & Grafana for Logging and Monitoring

```
helm repo add stable https://charts.helm.sh/stable
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm install grafana grafana/grafana
```
## Security Best Practices
```
Sonarqube Integration: Integrate Sonarqube for code quality analysis
OWASP Dependency-Check
Trivy File Scan & Image Scan
```
## Jenkinsfile has all the necessary stages included 

## License

This project is licensed under the terms of the MIT license. 
