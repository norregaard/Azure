module myTestModule 'br/public:avm/res/network/virtual-network:0.4.0' = {
  name: 'bicep-test-vnet'
  params: {
    name: 'vnet-conn-weu-004'
    addressPrefixes: ['10.104.0.0/18']
    subnets: [
      {
        addressPrefix: '10.104.0.0/24'
        name: 'snet-bicep-001'
      }
    ]
    peerings: [
      {
        allowForwardedTraffic: true
        allowGatewayTransit: false
        allowVirtualNetworkAccess: true
        remotePeeringAllowForwardedTraffic: true
        remotePeeringAllowVirtualNetworkAccess: true
        remotePeeringEnabled: true
        remotePeeringName: 'peered-to-bicep-vnet'
        remoteVirtualNetworkResourceId: '/subscriptions/fe82accc-f7cc-466f-9efe-1fd0143c3e57/resourceGroups/rg-netw-conn-001/providers/Microsoft.Network/virtualNetworks/vnet-conn-weu-001'
        useRemoteGateways: false
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
      Info: 'Deployed using bicep AVM module'
    }
  }
}
