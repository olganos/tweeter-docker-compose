#!/bin/bash   
# after creating a resource group
resourceGroup="tweeterResourceGroup"
resourceGroup="tweeterResourseGroup"

# Install the db-up extension
#az extension add --name db-up

# Create the Postgres database
az postgres up --resource-group $resourceGroup \
    --location westeurope \
    --server-name tweeterPostgresServer \
    --database-name tweeterIdentityDb \
    --admin-user adminusername \
    --admin-password _aDminpassword1 \
    --ssl-enforcement Enabled