# Terraform EKS Project

This project automates the deployment of an Amazon EKS cluster within a VPC that includes both public and private subnets. The infrastructure is managed using Terraform and can be deployed using GitHub Actions. Also once the infra is deployed, argocd along with a sample application can also be deployed for fully automated gitops architecture.

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

### Backend Configuration

This project uses an S3 bucket and DynamoDB table for Terraform state management. Follow the steps below to configure the backend:

#### Step 1: Create an S3 Bucket

Run the following AWS CLI command to create an S3 bucket for storing the Terraform state. Replace `<your-bucket-name>` with a unique bucket name.

```bash
aws s3api create-bucket --bucket <your-bucket-name> --region <your-region> --create-bucket-configuration LocationConstraint=<your-region>
```

Enable versioning on the bucket to keep a history of your state files:

```bash
aws s3api put-bucket-versioning --bucket <your-bucket-name> --versioning-configuration Status=Enabled
```

#### Step 2: Create a DynamoDB Table

Run the following command to create a DynamoDB table for state locking:

```bash
aws dynamodb create-table \
    --table-name <your-dynamodb-table-name> \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
```

#### Step 3: Update the `backend.tf` File

Update the `backend.tf` file in the project to use the S3 bucket and DynamoDB table:

```hcl
terraform {
  backend "s3" {
    bucket         = "<your-bucket-name>"
    key            = "terraform/state"
    region         = "<your-region>"
    dynamodb_table = "<your-dynamodb-table-name>"
    encrypt        = true
  }
}
```

#### Step 4: Initialize the Backend

Run the following command to initialize the backend:

```bash
terraform init
```

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
## Deploying ArgoCD and Sample Application

This project includes automation for deploying ArgoCD onto the EKS cluster and deploying a sample application through ArgoCD.

### Steps

1. **ArgoCD Deployment**:
   - ArgoCD is deployed using Terraform and Helm.
   - The ArgoCD server is exposed via a LoadBalancer service.

2. **Sample Application Deployment**:
   - A sample application (`guestbook`) is deployed using an ArgoCD `Application` manifest.

### Using GitHub Actions

1. **Trigger the Workflow**:
   - Push changes to the `main` branch to trigger the `deploy-argocd.yml` workflow.

2. **Access ArgoCD**:
   - Retrieve the ArgoCD server's external IP:
     ```bash
     kubectl get svc -n argocd argocd-server
     ```
   - Access the ArgoCD UI at `http://<external-ip>:80`.

3. **Login to ArgoCD**:
   - Default username: `admin`
   - Retrieve the initial password:
     ```bash
     kubectl get secret -n argocd argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
     ```

4. **Verify the Sample Application**:
   - Open the ArgoCD UI and verify that the `guestbook` application is deployed and synced.

### Conclusion

This setup automates the deployment of ArgoCD and a sample application onto the EKS cluster. Use the provided workflows and manifests to manage your applications efficiently.

