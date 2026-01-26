param remoteVnetPeeringId string
param variables_hubPeeringName string
param hubVnetName string
param spokePeeringSubnetName string
param hubPeeringSubnetName string

resource hubVnetName_variables_hubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-01-01' = {
  name: '${hubVnetName}${variables_hubPeeringName}'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: remoteVnetPeeringId
    }
    peerCompleteVnets: false
    localSubnetNames: [
      hubPeeringSubnetName
    ]
    remoteSubnetNames: [
      spokePeeringSubnetName
    ]
  }
}
