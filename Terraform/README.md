# Instructions for running Terraform files

There are multiple ways of running the files. One way, maybe the simplest, is to do it via the Cloud Shell in the Azure Portal.

To get started, see this link:
https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash

Commands to run:

> terraform init -upgrade
> terraform plan -out vnet-two-subnets.tfplan
> terraform apply vnet-two-subnets.tfplan

and to delete the resources again:

> terraform plan -destroy -out vnet-two-subnets.destroy.tfplan
> terraform apply vnet-two-subnets.destroy.tfplan

If you've create a Service Principal and added the credentials to the environment variables on your local machine, you can execute the bashrc script to load them into the session by running:

> . ~/.bashrc

And to view that they have been set:

> printenv | grep ARM

The MS documentation suggests that you add these environment variables into the Provider part of the template. However, this is not necessary. If you have loaded the variables, then both Plan and Apply will be able to read this info with no extra configuration required, see link below:

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret


