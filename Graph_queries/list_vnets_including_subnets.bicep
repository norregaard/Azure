module query 'br/public:avm/res/resource-graph/query:0.3.1' = {
  name: 'queryDeployment'
  params: {
    // Required parameters
    name: 'List VNets including subnets'
    query: 'resources \n| where type == "microsoft.network/virtualnetworks" \n| extend subnets = properties.subnets \n| mv-expand subnets \n| project \n\tsubscriptionId, \n\tvnetName = name, \n\tsubnetName = subnets.name, \n\taddressPrefix = subnets.properties.addressPrefix, \n\tnsg = subnets.properties.networkSecurityGroup.id, \n\trouteTable = subnets.properties.routeTable.id \n| order by subscriptionId, vnetName'
    location: 'global'
    queryDescription: 'Query that will show VNets including subnets'
  }
}
