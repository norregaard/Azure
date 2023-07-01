# PowerShell command to deploy the simple Win2k22 VM

Remember to navigate to the folder where the relevant files are located before running the command.

New-AzResourceGroupDeployment -Name deploy_wink22_vm -ResourceGroupName RESOURCE_GROUP_NAME `
-TemplateFile .\vm-srv-win2k22.json `
-TemplateParameterFile .\vm-srv-win2k22.parameters.json

The template: vm-srv-win2k22_with_IIS.json and its associated parameters file installs a win2k22 VM with and IIS server as well. It does this by using the "Microsoft.Compute/virtualMachines/extensions" resource that lets you run a PowerShell script post deployment. See here for more info: 

https://learn.microsoft.com/en-us/azure/azure-resource-manager/templates/template-tutorial-deploy-vm-extensions


