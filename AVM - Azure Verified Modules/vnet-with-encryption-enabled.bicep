param vnetName string = 'vnet-conn-weu-006'
param subnet_01_name string = 'snet-conn-weu-001'
param vnetAddressPrefixes array = ['10.106.0.0/18']
param subnetAddressPrefix string = '10.106.0.0/24'

module vnet 'br/public:avm/res/network/virtual-network:0.7.2' = {
  name: 'vnetDeployment'
  params: {
    name: vnetName
    addressPrefixes: vnetAddressPrefixes
    subnets: [
      {
        addressPrefix: subnetAddressPrefix
        name: subnet_01_name
        networkSecurityGroupResourceId: networksecuritygroup.outputs.resourceId
      }
    ]
    vnetEncryption: true
  }
}

module networksecuritygroup 'br/public:avm/res/network/network-security-group:0.5.1' = {
  name: 'nsgDeployment'
  params: {
    name: 'nsg-conn-weu-001'
    securityRules: [
      {
        name: 'Port_3389-Allow'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '2.100.200.60'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}
