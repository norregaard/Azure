param remoteVnetPeeringId string
param variables_hubPeeringName string
param hubVnetName string

resource hubVnetName_variables_hubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2019-11-01' = {
  name: '${hubVnetName}${variables_hubPeeringName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: remoteVnetPeeringId
    }
  }
}
