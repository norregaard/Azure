variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}

variable "RgName" {
  type        = string
  default     = "rg-tf-server-01"
  description = "Resource group name"
}

variable "prefix" {
  type        = string
  default     = "win-vm-tf"
  description = "Prefix of the resource name"
}

variable "subnetId" {
  type        = string
  default     = "/subscriptions/<SUB ID>/resourceGroups/<RG>/providers/Microsoft.Network/virtualNetworks/<VNET name>/subnets/<SUBNET name>"
  description = "Resource ID for the subnet"
}