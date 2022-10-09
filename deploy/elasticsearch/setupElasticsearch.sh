#!/bin/bash  
RESOURCE_GROUP="elasticResourceGroup"
LOCATION="westeurope"

DOCKER_CONTEXT_ACI="elasticcontext"

CONTAINER_REGISTRY_NAME="tweetercontainerregistry"

STORAGE_ACCOUNT="elastictweeterstoracc"
SHARE_ELASTICSEARCH_NAME="elasticsearch"

docker context use default

az login

echo "------ Resource group and storage account creating ------"

az group create --name $RESOURCE_GROUP --location $LOCATION

# create storage account 
az storage account create --resource-group $RESOURCE_GROUP \
    --name $STORAGE_ACCOUNT \
    --location $LOCATION \
    --sku Standard_LRS

echo "------ Get storage key ------"

STORAGE_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP --account-name $STORAGE_ACCOUNT --query "[0].value" --output tsv)

echo "------ Storage key ------"

echo $STORAGE_KEY

echo "------ Storage creating ------"

az storage share create --name $SHARE_LOGSTASH_NAME \
    --account-name $STORAGE_ACCOUNT \
    --account-key $STORAGE_KEY

az storage file upload -s $SHARE_LOGSTASH_NAME \
    --account-name $STORAGE_ACCOUNT \
    --source ./config.conf \
    --account-key $STORAGE_KEY

az storage share create --name $SHARE_ELASTICSEARCH_NAME \
    --account-name $STORAGE_ACCOUNT \
    --account-key $STORAGE_KEY

echo "------ Registry ------"

az acr build --image elasticsearch:v1 \
    --registry $CONTAINER_REGISTRY_NAME \
    --file Dockerfile .

echo "------ Context creating ------"

# create Azure context
docker login azure
docker context create aci $DOCKER_CONTEXT_ACI \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION

echo "------ Application deploying ------"

# deploy application to Azure Container Instances
docker context use $DOCKER_CONTEXT_ACI

az acr login --name $CONTAINER_REGISTRY_NAME

docker compose up
