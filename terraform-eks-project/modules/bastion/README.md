# This file provides documentation on how to use the bastion module, including variable descriptions and examples.

## Bastion Host Module

This module creates a bastion host in the public subnet of the VPC. The bastion host allows secure access to the private subnet where the EKS cluster is deployed.

### Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "bastion" {
  source      = "../modules/bastion"
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_id        = var.vpc_id
  subnet_id     = var.public_subnet_id
}
```

### Input Variables

| Variable        | Description                                      | Type   | Default | Required |
|-----------------|--------------------------------------------------|--------|---------|----------|
| instance_type   | The type of EC2 instance to use for the bastion host. | string | `t2.micro` | no       |
| key_name        | The name of the key pair to use for SSH access. | string |         | yes      |
| vpc_id          | The ID of the VPC where the bastion host will be created. | string |         | yes      |
| public_subnet_id| The ID of the public subnet where the bastion host will be deployed. | string |         | yes      |

### Outputs

| Output          | Description                                      |
|-----------------|--------------------------------------------------|
| bastion_ip      | The public IP address of the bastion host.      |

### Accessing the EKS Cluster

To access the EKS cluster from the bastion host, follow these steps:

1. SSH into the bastion host using the key pair specified:
   ```bash
   ssh -i /path/to/your/key.pem ec2-user@<bastion_ip>
   ```

2. Once logged in, configure `kubectl` to access the EKS cluster:
   ```bash
   aws eks --region <region> update-kubeconfig --name <cluster_name>
   ```

3. You can now run `kubectl` commands to interact with your EKS cluster:
   ```bash
   kubectl get nodes
   ```

### Example

Here is a complete example of how to use the bastion module in your Terraform configuration:

```hcl
provider "aws" {
  region = "us-west-2"
}

module "vpc" {
  source = "../modules/vpc"
  # VPC variables
}

module "eks" {
  source = "../modules/eks"
  # EKS variables
}

module "bastion" {
  source          = "../modules/bastion"
  instance_type   = "t2.micro"
  key_name        = "my-key-pair"
  vpc_id          = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_ids[0]
}
```