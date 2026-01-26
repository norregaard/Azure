param vnetName string
param subnetName string
param subnetAddressPrefix string
param hubVnetName string
param spokePeeringSubnetName string
param hubPeeringSubnetName string
param nsgName string

@description('Hub VNet sub')
param HubSubscriptionId string

@description('Hub VNet RG')
param hubVnetRG string

@description('Network configuration to deploy vnets, subnets and nsgs')
param networkConfiguration object

@description('Location should be a parameter with default value. Do not change!')
param rgLocation string = resourceGroup().location

var spokePeeringName = '/peered-to-${hubVnetName}'
var hubPeeringName = '/peered-to-${vnetName}'

resource vnet 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: vnetName
  location: rgLocation
  properties: {
    addressSpace: {
      addressPrefixes: networkConfiguration.vnetAddressPrefix
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetAddressPrefix
        }
      }
    ]
  }
}

resource nsg 'Microsoft.Network/networkSecurityGroups@2025-01-01' = {
  name: nsgName
  location: rgLocation
}

resource spokePeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-01-01' = {
  name: '${vnetName}${spokePeeringName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: resourceId(HubSubscriptionId, hubVnetRG, 'Microsoft.Network/virtualNetworks', hubVnetName)
    }
    peerCompleteVnets: false
    localSubnetNames: [
      spokePeeringSubnetName
    ]
    remoteSubnetNames: [
      hubPeeringSubnetName
    ]
  }
  dependsOn: [
    vnet
  ]
}

module hubPeering '../bicep-modules/hubPeering_module_subnet_peering.bicep' = {
  name: 'nestedTemplate_${vnetName}'
  scope: resourceGroup(HubSubscriptionId, hubVnetRG)
  params: {
    remoteVnetPeeringId: vnet.id
    variables_hubPeeringName: hubPeeringName
    hubVnetName: hubVnetName
    spokePeeringSubnetName: spokePeeringSubnetName
    hubPeeringSubnetName: hubPeeringSubnetName
  }
}
