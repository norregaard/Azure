module query 'br/public:avm/res/resource-graph/query:0.3.1' = {
  name: 'queryDeployment'
  params: {
    // Required parameters
    name: 'List all resources including subscription name'
    query: 'resources \n| join kind=inner ( \n\tresourcecontainers \n\t| where type == "microsoft.resources/subscriptions" \n\t| project subscriptionId, subscriptionName = name) \n\ton subscriptionId \n| project subscriptionName, resourceGroup, name, type, tags, location'
    location: 'global'
    queryDescription: 'Lists all resources with subscription name as opposed to subscription ID'
  }
}
