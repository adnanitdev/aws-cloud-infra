# Terraform EKS Project

This project automates the deployment of an Amazon EKS cluster within a VPC that includes both public and private subnets. The infrastructure is managed using Terraform and can be deployed using GitHub Actions.

## Project Structure

- `modules/`: Contains reusable Terraform modules for VPC, EKS, and Bastion host.
- `environments/`: Contains environment-specific configurations for development and production.
- `.github/workflows/`: Contains GitHub Actions workflows for Terraform operations.
- `backend.tf`: Configures the backend for storing Terraform state.
- `main.tf`: Entry point for the Terraform configuration.
- `outputs.tf`: Exports outputs for the entire Terraform configuration.
- `providers.tf`: Specifies required providers.
- `variables.tf`: Defines input variables for the overall configuration.

## Deployment Instructions

### Using GitHub Actions

1. **Create a GitHub Repository**: Push your code to a GitHub repository.

2. **Set Up Secrets**: In your GitHub repository, navigate to `Settings` > `Secrets and variables` > `Actions` and add the following secrets:
   - `AWS_ACCESS_KEY_ID`: Your AWS access key ID.
   - `AWS_SECRET_ACCESS_KEY`: Your AWS secret access key.
   - `AWS_REGION`: The AWS region where you want to deploy the infrastructure.

3. **Trigger Workflows**: You can trigger the workflows manually or set them to run on specific events (like push to main branch).

   - **Terraform Plan**: This workflow will run `terraform plan` to show the changes that will be made.
   - **Terraform Apply**: This workflow will run `terraform apply` to apply the changes and create the infrastructure.
   - **Terraform Destroy**: This workflow will run `terraform destroy` to tear down the infrastructure.

### Accessing the EKS Cluster

To access the EKS cluster, you will need to use a Bastion host that is deployed in the public subnet. Follow these steps:

1. **SSH into the Bastion Host**:
   - Use the public IP address of the Bastion host to SSH into it.
   - Example command:
     ```
     ssh -i <your-key-pair>.pem ec2-user@<bastion-public-ip>
     ```

2. **Configure kubectl**:
   - Once logged into the Bastion host, configure `kubectl` to access the EKS cluster. You can do this by running:
     ```
     aws eks --region <your-region> update-kubeconfig --name <your-cluster-name>
     ```

3. **Access the Cluster**:
   - You can now run `kubectl` commands to interact with your EKS cluster from the Bastion host.

## Conclusion

This project provides a complete setup for deploying an EKS cluster with a VPC, public and private subnets, and a Bastion host for secure access. Follow the instructions above to deploy and manage your infrastructure efficiently.