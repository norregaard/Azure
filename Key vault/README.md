# Instructions for Key Vault with private endpoint

Update the parameters file, keyvault-w-privateendpoint-001.parameters.json, with KV name, PE name, and subnet ID.
The VNet, subnet, and a resource group to place the key vault in must exist in advance. A private DNS zone should also exist.

The ARM template can be run with the following command (from e.g. the cloud shell):

New-AzResourceGroupDeployment -Name deploy_kv -ResourceGroupName <RESOURCE GROUP NAME> `
-TemplateFile .\keyvault-w-privateendpoint-001.json `
-TemplateParameterFile .\keyvault-w-privateendpoint-001.parameters.json
  
See here for more info:
https://www.vi-tips.com/2023/06/azure-deploy-key-vault-with-private.html
