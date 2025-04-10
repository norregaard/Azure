module query 'br/public:avm/res/resource-graph/query:0.3.1' = {
  name: 'queryDeployment'
  params: {
    // Required parameters
    name: 'List custom DNS servers on VNets'
    query: 'resources \n| where type == "microsoft.network/virtualnetworks" \n| extend dnsServers = properties.dhcpOptions.dnsServers \n| project id, name, dnsServers'
    location: 'global'
    queryDescription: 'This query is useful for verifying that the correct custom DNS servers have been configured on VNets'
  }
}
