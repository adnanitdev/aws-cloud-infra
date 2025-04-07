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

