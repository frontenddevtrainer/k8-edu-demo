Create Cluster

az aks create --resource-group edu-az400-batch --name aks-hello-world-v2 --node-count 1 --attach-acr eduaz400batchdemo --enable-managed-identity --generate-ssh-keys --node-vm-size Standard_B2ms


MacOS 
sed -i 's|image: hello-world-aks:latest|image: eduaz400batchdemo.azurecr.io/hello-world-aks:latest|g' k8s-deployment.yaml

Windows
(Get-Content k8s-deployment.yaml) -replace 'image: hello-world-aks:latest', 'image: eduaz400batchdemo.azurecr.io/hello-world-aks:latest' | Set-Content k8s-deployment.yaml
Windows with Git Bash 
sed -i 's|image: hello-world-aks:latest|image: eduaz400batchdemo.azurecr.io/hello-world-aks:latest|g' k8s-deployment.yaml


https://kubernetes.io/docs/reference/kubectl/

az aks get-credentials --resource-group edu-az400-batch --name aks-hello-world-v2


az acr repository list --name eduaz400batchdemo --output table

ACR_ID=$(az acr show --name eduaz400batchdemo --query id --output tsv)
AKS_SP_ID=$(az aks show --resource-group edu-az400-batch --name aks-hello-world-v2 --query "identityProfile.kubeletidentity.objectId" -o tsv)
az role assignment create --assignee $AKS_SP_ID --role AcrPull --scope $ACR_ID


docker buildx build --platform linux/amd64 -t eduaz400batchdemo.azurecr.io/hello-world-aks:latest --push .


kubectl autoscale deployment hello-aks --min=1 --max=5 --cpu-percent=70