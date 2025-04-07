# Terraform EKS Module

This module is responsible for creating an Amazon EKS (Elastic Kubernetes Service) cluster within a private subnet. It includes the necessary configurations for the EKS cluster, node groups, and IAM roles.

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "eks" {
  source          = "../modules/eks"
  cluster_name    = var.cluster_name
  node_instance_type = var.node_instance_type
  desired_capacity = var.desired_capacity
  ...
}
```

## Input Variables

| Variable                | Description                                           | Type   | Default |
|------------------------|-------------------------------------------------------|--------|---------|
| `cluster_name`         | The name of the EKS cluster                           | string | n/a     |
| `node_instance_type`   | The EC2 instance type for the worker nodes           | string | "t3.medium" |
| `desired_capacity`     | The desired number of worker nodes                   | number | 2       |
| `vpc_id`               | The VPC ID where the EKS cluster will be created     | string | n/a     |
| `subnet_ids`           | List of subnet IDs for the EKS cluster               | list   | n/a     |

## Outputs

| Output                  | Description                                           |
|------------------------|-------------------------------------------------------|
| `cluster_name`         | The name of the EKS cluster                           |
| `cluster_endpoint`     | The endpoint of the EKS cluster                       |
| `cluster_certificate_authority_data` | The certificate authority data for the cluster |

## Accessing the EKS Cluster

To access the EKS cluster, you will need to set up a bastion host in the public subnet. Once the bastion host is running, you can SSH into it and then use `kubectl` to interact with the EKS cluster.

1. SSH into the bastion host using its public IP address.
2. Ensure that `kubectl` is installed on the bastion host.
3. Configure `kubectl` to use the EKS cluster by running:

   ```bash
   aws eks --region <region> update-kubeconfig --name <cluster_name>
   ```

4. You can now use `kubectl` commands to manage your EKS cluster.

## Example

Here is an example of how to define the EKS module in your Terraform configuration:

```hcl
module "eks" {
  source              = "../modules/eks"
  cluster_name        = "my-eks-cluster"
  node_instance_type  = "t3.medium"
  desired_capacity    = 2
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
}
```

Make sure to replace the placeholder values with your actual configuration.