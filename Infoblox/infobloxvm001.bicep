param virtualMachine_name string
param nameSeed string
param VNetRG string
param adminUsername string
@secure()
param adminPassword string
param vnet_id string
param location string = resourceGroup().location
param availabilityZones array
param plan_name string
param plan_product string
param plan_publisher string
param imageReference_version string
param vmSize string
param nic_lan1_privateIP string
param nic_lan1_ha_cluster_privateIP string
param nic_mgmt_privateIP string
param lan1_subnet_name string
param mgmt_subnet_name string
param diskSizeGB int

var nic_vmdnsi_lan1_name = '${virtualMachine_name}-lan1'
var nic_vmdnsi_lan1_ha_cluster_name = '${virtualMachine_name}-lan1-ha-cluster'
var nic_vmdnsi_mgmt_name = '${virtualMachine_name}-mgmt'

var NSG_name = '${virtualMachine_name}-securityGroup'

var roleDefinitionId = subscriptionResourceId(
  'Microsoft.Authorization/roleDefinitions',
  '36444241-3346-3545-3336-314545354434'
)

var principalId = virtualMachine_resource.identity.principalId

resource virtualMachine_resource 'Microsoft.Compute/virtualMachines@2024-11-01' = {
  name: virtualMachine_name
  location: location
  zones: availabilityZones
  identity: {
    type: 'SystemAssigned'
  }
  plan: {
    name: plan_name
    product: plan_product
    publisher: plan_publisher
  }
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      imageReference: {
        publisher: plan_publisher
        offer: plan_product
        sku: plan_name
        version: imageReference_version
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachine_name}-osdisk'
        createOption: 'FromImage'
        caching: 'ReadOnly'
        managedDisk: {
          storageAccountType: 'Premium_LRS'
        }
        deleteOption: 'Delete'
        diskSizeGB: diskSizeGB
      }
      dataDisks: []
    }
    osProfile: {
      computerName: virtualMachine_name
      adminUsername: adminUsername
      adminPassword: adminPassword
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic_lan1.id
          properties: {
            primary: true
          }
        }
        {
          id: nic_mgmt.id
          properties: {
            primary: false
          }
        }
        {
          id: nic_lan1_ha_cluster.id
          properties: {
            primary: false
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource nic_lan1 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: nic_vmdnsi_lan1_name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: nic_lan1_privateIP
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: '${vnet_id}/subnets/${lan1_subnet_name}'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource nic_lan1_ha_cluster 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: nic_vmdnsi_lan1_ha_cluster_name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: nic_lan1_ha_cluster_privateIP
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: '${vnet_id}/subnets/${lan1_subnet_name}'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

resource nic_mgmt 'Microsoft.Network/networkInterfaces@2024-07-01' = {
  name: nic_vmdnsi_mgmt_name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAddress: nic_mgmt_privateIP
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: '${vnet_id}/subnets/${mgmt_subnet_name}'
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}

/*
resource NSG_resource 'Microsoft.Network/networkSecurityGroups@2024-07-01' = {
  name: NSG_name
  location: location
  properties: {
    securityRules: [
      {
        name: 'SSH'
        properties: {
          description: 'Allow SSH'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '22'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
      {
        name: 'DNS'
        properties: {
          description: 'Allow DNS'
          protocol: 'Udp'
          sourcePortRange: '*'
          destinationPortRange: '53'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 101
          direction: 'Inbound'
        }
      }
      {
        name: 'HTTPS'
        properties: {
          description: 'Allow HTTPS'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '443'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 102
          direction: 'Inbound'
        }
      }
      {
        name: 'Grid_traffic_UDP_1194_in'
        properties: {
          description: 'Allow vNIOS Grid traffic 1194 Inbound'
          protocol: 'Udp'
          sourcePortRange: '*'
          destinationPortRange: '1194'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 103
          direction: 'Inbound'
        }
      }
      {
        name: 'Grid_traffic_UDP_2114_in'
        properties: {
          description: 'Allow vNIOS Grid traffic 2114 Inbound'
          protocol: 'Udp'
          sourcePortRange: '*'
          destinationPortRange: '2114'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 104
          direction: 'Inbound'
        }
      }
      {
        name: 'Grid_traffic_UDP_1194_out'
        properties: {
          description: 'Allow vNIOS Grid traffic 1194 Outbound'
          protocol: 'Udp'
          sourcePortRange: '*'
          destinationPortRange: '1194'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 105
          direction: 'Outbound'
        }
      }
      {
        name: 'Grid_traffic_UDP_2114_out'
        properties: {
          description: 'Allow vNIOS Grid traffic 2114 Outbound'
          protocol: 'Udp'
          sourcePortRange: '*'
          destinationPortRange: '2114'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 106
          direction: 'Outbound'
        }
      }
    ]
  }
}
*/

// Role def ID can be found with: az role definition list --name "SHB WID Network Infoblox High Availability Cluster Contributor"

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, virtualMachine_name, nameSeed)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}

module roleAssignmentVnetRG './SAMI_roleAssignment.bicep' = {
  name: 'roleAssignmentVnetRG'
  scope: resourceGroup(VNetRG)
  params: {
    principalId: principalId
    roleDefinitionId: roleDefinitionId
    virtualMachine_name: virtualMachine_name
    nameSeed: nameSeed
  }
}
