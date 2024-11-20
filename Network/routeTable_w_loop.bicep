@description('Route table name')
param routeTableName string = 'udr-dbricks-to-internet-001'

@description('Route table location')
param location string = resourceGroup().location

@description('Disable the routes learned by BGP on the route table')
param disableBgpRoutePropagation bool = false

@description('Array containing routes. For properties format refer to https://docs.microsoft.com/en-us/azure/templates/microsoft.network/routetables?tabs=bicep#routepropertiesformat')
param routes array = [
  {
    name: 'adb-servicetag'
    addressPrefix: 'AzureDatabricks'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.0.1.4'
  }
  {
    name: 'adb-metastore'
    addressPrefix: 'Sql.Swedencentral'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.0.1.4'
  }
  {
    name: 'adb-storage'
    addressPrefix: 'Storage.Swedencentral'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.0.1.4'
  }
  {
    name: 'adb-eventhub'
    addressPrefix: 'Eventhub.Swedencentral'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.0.1.4'
  }
  {
    name: 'dbricks-To-On-Prem'
    addressPrefix: '0.0.0.0/0'
    nextHopType: 'VirtualAppliance'
    nextHopIpAddress: '10.0.0.4'
  }
]

resource routeTable 'Microsoft.Network/routeTables@2024-03-01' = {
  name: routeTableName
  location: location
  properties: {
    disableBgpRoutePropagation: disableBgpRoutePropagation
    routes: [for route in routes: {
      name: route.name
      properties: {
        addressPrefix: route.addressPrefix
        nextHopIpAddress: route.?nextHopIpAddress ?? null
        nextHopType: route.nextHopType
      }
    }]
  }
}
