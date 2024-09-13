module privateEndpoint 'br/public:avm/res/network/private-endpoint:0.8.0' = {
  name: 'privateEndpointDeployment'
  params: {
    // Required parameters
    name: 'pe-ssablob001deltmp'
    subnetResourceId: '/subscriptions/fe82accc-f7cc-466f-9efe-1fd0143c3e57/resourceGroups/rg-netw-conn-001/providers/Microsoft.Network/virtualNetworks/vnet-conn-weu-001/subnets/snet-conn-weu-001'
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
