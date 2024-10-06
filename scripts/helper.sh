#!/bin/bash
# Set variables
resourcegroup="tf-state"
storageaccountname="jswtfstate"
containername="tfstate"
azureadadmingroup="153f8e8f-3566-46f3-9dbf-5b97a8502721"
subscription="a900772c-eb89-4701-9e62-1086c9c9354b"
tags=()
ipaddress="188.74.74.189"
location="uksouth"

# Login to Azure using device code
azlogin() {
    az login --use-device-code --scope https://graph.microsoft.com//.default
    az account set --subscription $subscription
}

createresourcegroup () {
    az group create -l $location -n $resourcegroup --tags "${tags[@]}"
}

createtfstatestorageaccount () {
    # Create Storage Account
    az storage account create -n $storageaccountname -g $resourcegroup --kind StorageV2 --require-infrastructure-encryption --allow-shared-key-access true -l $location --subscription $subscription --sku Standard_GRS --min-tls-version TLS1_2 --https-only true --default-action Deny --allow-blob-public-access false --tags "${tags[@]}"

    # Enable versioning and soft delete
    az storage account blob-service-properties update --account-name $storageaccountname --resource-group $resourcegroup --enable-delete-retention true --delete-retention-days 14 --enable-versioning true

    # Add rule to allow access from trusted IP
    az storage account network-rule add -g $resourcegroup --account-name $storageaccountname --ip-address $ipaddress

    # Wait 20 seconds to allow network rule to apply
    sleep 20
    # Create storage container
    az storage container create -n $containername --account-name $storageaccountname --auth-mode login

    # Add role asignment to allow writes
    az role assignment create --assignee $azureadadmingroup --role "Storage Blob Data Owner" --scope "/subscriptions/$subscription/resourceGroups/$resourcegroup/providers/Microsoft.Storage/storageAccounts/$storageaccountname/blobServices/default/containers/$containername"
}

addiptotfstatestorageaccount(){
    ip="${1:-$(curl ifconfig.me)}"  
    az storage account network-rule add -g $resourcegroup --account-name $storageaccountname --ip-address "$ip"
}

getsshkeyfromkv(){
    az keyvault secret show --name "$1" --vault-name "$2" | jq '.value' | base64 -di | tee "$3"
}

bootstrapflux(){
     flux bootstrap github   --token-auth   --owner=jsw1993   --repository=eng2024   --branch=main   --path=flux/clusters/eng2024-aks   --personal
}