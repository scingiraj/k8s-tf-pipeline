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

## Installing Calico on Amazon EKS
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

## License

This project is licensed under the terms of the MIT license. 
