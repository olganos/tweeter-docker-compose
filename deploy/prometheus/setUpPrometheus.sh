#!/bin/bash  
RESOURCE_GROUP="prometheusResourceGroup"
LOCATION="westeurope"

DOCKER_CONTEXT_ACI="prometheuscontext"

#CONTAINER_REGISTRY_NAME="prometheustweetercontainerregistry"

STORAGE_ACCOUNT="prometheustweeterstoracc"
SHARE_GRAFANA_NAME="grafana"
SHARE_PROM_NAME="prometheus"

docker context use default

az login

echo "------ Resource group and storage account creating ------"

az group create --name $RESOURCE_GROUP --location $LOCATION

# create storage account for prometheus
az storage account create --resource-group $RESOURCE_GROUP \
    --name $STORAGE_ACCOUNT \
    --location $LOCATION \
    --sku Standard_LRS

echo "------ Get storage key ------"

STORAGE_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query "[0].value" --output tsv)

echo "------ Storage key ------"
echo $STORAGE_KEY

echo "------ Storage creating ------"

az storage share create --name $SHARE_PROM_NAME --account-name $STORAGE_ACCOUNT --account-key $STORAGE_KEY
az storage file upload -s $SHARE_PROM_NAME --account-name $STORAGE_ACCOUNT --source ./prometheus.yml --account-key $STORAGE_KEY

az storage share create --name $SHARE_GRAFANA_NAME --account-name $STORAGE_ACCOUNT --account-key $STORAGE_KEY

# Not sure this is a nesessarily step
# echo "------ Container registry creating ------"

# az acr create --resource-group $RESOURCE_GROUP --name $CONTAINER_REGISTRY_NAME --sku Basic

# az acr login --name $CONTAINER_REGISTRY_NAME

#docker-compose push

echo "------ Context creating ------"

create Azure context
docker login azure
docker context create aci $DOCKER_CONTEXT_ACI --resource-group $RESOURCE_GROUP --location $LOCATION

echo "------ Application deploying ------"

# deploy application to Azure Container Instances
docker context use $DOCKER_CONTEXT_ACI

docker compose up