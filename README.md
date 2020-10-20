This webviz instance has been automatically created from configuration file.

You can run it locally by running:

  cd THISFOLDER
  python ./webviz_app.py

If you want to upload it to e.g. Azure Container Registry, you can do e.g.

  cd THISFOLDER
  az acr build --registry $ACR_NAME --image $IMAGE_NAME . 

assuming you have set the environment variables $ACR_NAME and $IMAGE_NAME.



## Use Azure blob storage

pip install azure-cli

SUBSCRIPTION_NAME="my-subscription"
RESOURCE_GROUP="my-resource-group"
STORAGE_NAME="storagename"
CONTAINER_NAME="containername"

az login
az account set --subscription $SUBSCRIPTION_NAME
az group create --name $RESOURCE_GROUP --location norwayeast

az storage account create \
    --name $STORAGE_NAME \
    --resource-group $RESOURCE_GROUP \
    --location northeurope \
    --sku Standard_ZRS \
    --encryption-services blob

az storage container create \
    --account-name $STORAGE_NAME \
    --name $CONTAINER_NAME \
    --auth-mode login

az ad signed-in-user show --query objectId -o tsv | az role assignment create \
    --role "Storage Blob Data Contributor" \
    --assignee @- \
    --scope "/subscriptions/<INSERT_SUBSCRIPTION_ID>/resourceGroups/{$RESOURCE_GROUP}/providers/Microsoft.Storage/storageAccounts/{$STORAGE_NAME}"

az storage blob upload-batch \
    --account-name $STORAGE_NAME \
    --destination $CONTAINER_NAME/webviz_storage \
    --auth-mode login \
    --source ./webviz_storage
