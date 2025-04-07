# Terraform VPC Module

This module creates a Virtual Private Cloud (VPC) with both public and private subnets in AWS. It also sets up necessary components such as route tables and internet gateways.

## Usage

To use this module, include it in your Terraform configuration as follows:

```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr          = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24"]
}
```

## Inputs

| Name                     | Description                                       | Type          | Default       |
|--------------------------|---------------------------------------------------|---------------|---------------|
| `vpc_cidr`               | The CIDR block for the VPC                        | `string`      | n/a           |
| `public_subnet_cidrs`    | List of CIDR blocks for public subnets            | `list(string)`| n/a           |
| `private_subnet_cidrs`   | List of CIDR blocks for private subnets           | `list(string)`| n/a           |

## Outputs

| Name                     | Description                                       |
|--------------------------|---------------------------------------------------|
| `vpc_id`                 | The ID of the created VPC                         |
| `public_subnet_ids`      | List of IDs of the created public subnets         |
| `private_subnet_ids`     | List of IDs of the created private subnets        |

## Example

Here is an example of how to call this module in your Terraform configuration:

```hcl
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr          = "10.0.0.0/16"
  public_subnet_cidrs = ["10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.2.0/24"]
}
```

## Accessing the EKS Cluster

To access the EKS cluster created in the private subnet, you will need to set up a bastion host in the public subnet. This bastion host will allow you to SSH into the private subnet and interact with the EKS cluster.

1. Deploy the bastion host using the bastion module.
2. SSH into the bastion host using its public IP address.
3. From the bastion host, you can use `kubectl` to interact with the EKS cluster.

Make sure to configure your `kubectl` context to point to the EKS cluster endpoint, which can be obtained from the outputs of the EKS module.