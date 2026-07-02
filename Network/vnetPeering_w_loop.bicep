targetScope = 'resourceGroup'

param application string
param region string
param identifier string

param hubPeerings array

var localVnetName = 'vnet-${application}-${region}-${identifier}'
var currentSubscriptionId = subscription().subscriptionId

resource localVnet 'Microsoft.Network/virtualNetworks@2025-07-01' existing = {
  name: localVnetName
}

resource hubVnets 'Microsoft.Network/virtualNetworks@2025-07-01' existing = [
  for peering in hubPeerings: {
    name: peering.hubVnetName
    scope: resourceGroup(peering.?subscriptionId ?? currentSubscriptionId, peering.hubResourceGroup)
  }
]

resource localToHubPeerings 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-07-01' = [
  for (peering, i) in hubPeerings: {
    parent: localVnet
    name: 'peered-to-${peering.hubVnetName}'
    properties: {
      allowVirtualNetworkAccess: true
      allowForwardedTraffic: true
      allowGatewayTransit: false
      useRemoteGateways: false
      remoteVirtualNetwork: {
        id: hubVnets[i].id
      }
    }
  }
]

module hubToLocalPeerings './vnetPeering_w_loop_module.bicep' = [
  for peering in hubPeerings: {
    name: 'remote-peering-${peering.hubVnetName}'
    scope: resourceGroup(peering.?subscriptionId ?? currentSubscriptionId, peering.hubResourceGroup)
    params: {
      hubVnetName: peering.hubVnetName
      localVnetName: localVnetName
      localVnetId: localVnet.id
    }
  }
]
