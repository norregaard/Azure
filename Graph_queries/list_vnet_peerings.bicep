module query 'br/public:avm/res/resource-graph/query:0.3.1' = {
  name: 'queryDeployment'
  params: {
    // Required parameters
    name: 'List all VNet peerings'
    query: 'Resources \n| where type == "microsoft.network/virtualnetworks" \n| extend peerings = properties.virtualNetworkPeerings \n| mv-expand peerings \n| project  \n\tsubscriptionId, \n\tvnetName = name, \n\tpeeringName = peerings.name, \n\tremoteVnet = peerings.properties.remoteVirtualNetwork.id, \n\tallowGatewayTransit = peerings.properties.allowGatewayTransit, \n\tpeeringState = peerings.properties.peeringState \n| where peeringState == "Connected"'
    location: 'global'
    queryDescription: 'Lists out all VNet peerings without having to travers each VNet'
  }
}
