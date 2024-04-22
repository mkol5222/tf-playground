#!/bin/bash

set -euo pipefail

export SPNAME='52-azure-lab-c'

# create and note deployment credentials, where relevant
SUBSCRIPTION_ID=$(az account list -o json | jq -r '.[]|select(.isDefault)|.id')
echo "Subscription: $SUBSCRIPTION_ID"
# note credentials for config
AZCRED=$(az ad sp create-for-rbac --name $SPNAME --role="Owner" --scopes="/subscriptions/$SUBSCRIPTION_ID")
# echo "$AZCRED" | jq .
CLIENT_ID=$(echo "$AZCRED" | jq -r .appId)
CLIENT_SECRET=$(echo "$AZCRED" | jq -r .password)
TENANT_ID=$(echo "$AZCRED" | jq -r .tenant)

echo
echo 'Your input for terraform.tfvars'
echo "# SP ${SPNAME}"
cat << EOF
client_secret = "$CLIENT_SECRET"
client_id = "$CLIENT_ID"
tenant_id = "$TENANT_ID"
subscription_id = "$SUBSCRIPTION_ID"
EOF

echo