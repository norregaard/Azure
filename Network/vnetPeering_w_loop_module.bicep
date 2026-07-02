targetScope = 'resourceGroup'

param hubVnetName string
param localVnetName string
param localVnetId string

resource hubVnet 'Microsoft.Network/virtualNetworks@2025-07-01' existing = {
  name: hubVnetName
}

resource hubToLocalPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-07-01' = {
  parent: hubVnet
  name: 'peered-to-${localVnetName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: localVnetId
    }
  }
}
