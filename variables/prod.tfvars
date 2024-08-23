project = "test"
env = "test"
region = "eu-west-3"
node_volume_size = "30"
key_pair_name = "ec2-keypair"
private_subnet_1_cidr = "10.0.10.0/24"
private_subnet_2_cidr = "10.0.20.0/24"
public_subnet_1_cidr = "10.0.30.0/24"
public_subnet_2_cidr = "10.0.40.0/24"
vpc_cidr = "10.0.0.0/16"

node_groups_config = {
  "object1" = {
    instance_types = ["t2.xlarge"]
    capacity_type  = "ON_DEMAND"
    scaling_config = {
      min_size     = 0
      max_size     = 10
      desired_size = 1    
    }
    update_config = {
      max_unavailable = 1
    }
  }
}
