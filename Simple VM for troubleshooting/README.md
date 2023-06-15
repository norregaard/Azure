# PowerShell command to deploy the simple Win2k22 VM

Remember to navigate to the folder where the relevant files are located before running the command.

New-AzResourceGroupDeployment -Name deploy_wink22_vm -ResourceGroupName RESOURCE_GROUP_NAME `
-TemplateFile .\vm-srv-win2k22.json `
-TemplateParameterFile .\vm-srv-win2k22.parameters.json
