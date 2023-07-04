# Instructions for running Terraform files

There are multiple ways of running the files. One way, maybe the simplest, is to do it via the Cloud Shell in the Azure Portal.

To get started, see this link:
https://learn.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash

Commands to run:

> terraform init -upgrade
> terraform plan -out vnet-two-subnets.tfplan
> terraform apply vnet-two-subnets.tfplan

