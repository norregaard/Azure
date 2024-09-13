module privateEndpoint 'br/public:avm/res/network/private-endpoint:0.8.0' = {
  name: 'privateEndpointDeployment'
  params: {
    // Required parameters
    name: 'pe-ssablob001deltmp'
    subnetResourceId: '<subnet resource id>'
    // Non-required parameters
    privateDnsZoneGroup: {
      name: 'deployedByBicepModdule'
      privateDnsZoneGroupConfigs: [
        {
          name: 'privateDnsZone'
          privateDnsZoneResourceId: '<private DNS zone resource id>'
        }
      ]
    }
    privateLinkServiceConnections: [
      {
        name: 'pe-ssablob001deltmp'
        properties: {
          groupIds: [
            'blob'
          ]
          privateLinkServiceId: '<storage account resource id>'
          requestMessage: 'Hey there'
        }
      }
    ]
  }
}
