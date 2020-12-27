aws eks --region eu-central-1 update-kubeconfig --name fjacky-todoapp
kubectl apply -f frontendDeployment.yaml
kubectl apply -f frontendService.yaml