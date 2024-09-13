module myTestModule 'br/public:avm/res/network/virtual-network:0.4.0' = {
  name: 'bicep-test-vnet'
  params: {
    name: '<vnet name>'
    addressPrefixes: ['10.104.0.0/18']
    subnets: [
      {
        addressPrefix: '10.104.0.0/24'
        name: '<subnet name>'
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
        remoteVirtualNetworkResourceId: '<vnet reosurce id>'
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
