
param location string = resourceGroup().location

param environment string
param region string
param application string
param identifier string
param hubIdentifier string
param snet1Identifier string
param snet2Identifier string
@minLength(2)
param frontendIps string[]
@minLength(2)
param backendPool1Ips string[]
@minLength(2)
param backendPool2Ips string[]
param tags object

var loadBalancerName = 'lb-${application}-${environment}-${region}-${identifier}'
var vnetName = 'vnet-${application}-${region}-${hubIdentifier}'

var frontendSubnet1Name = 'snet-${application}-${region}-${snet1Identifier}'
var frontendSubnet2Name = 'snet-${application}-${region}-${snet2Identifier}'

var frontend1Name = 'fe-${application}-${environment}-${region}-001'
var frontend2Name = 'fe-${application}-${environment}-${region}-002'

var backendPool1Name = 'bep-${application}-${environment}-${region}-001'
var backendPool2Name = 'bep-${application}-${environment}-${region}-002'

var probeName = 'hp-${application}-${environment}-${region}-001'
var rule1Name = '${frontend1Name}-rule'
var rule2Name = '${frontend2Name}-rule'

var loadBalancerId = resourceId('Microsoft.Network/loadBalancers', loadBalancerName)
var frontend1Id = '${loadBalancerId}/frontendIPConfigurations/${frontend1Name}'
var frontend2Id = '${loadBalancerId}/frontendIPConfigurations/${frontend2Name}'
var backendPool1Id = resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancerName, backendPool1Name)
var backendPool2Id = resourceId('Microsoft.Network/loadBalancers/backendAddressPools', loadBalancerName, backendPool2Name)
var probeId = '${loadBalancerId}/probes/${probeName}'

resource vnet 'Microsoft.Network/virtualNetworks@2025-05-01' existing = {
  name: vnetName
}

resource frontendSubnet1 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' existing = {
  name: frontendSubnet1Name
  parent: vnet
}

resource frontendSubnet2 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' existing = {
  name: frontendSubnet2Name
  parent: vnet
}

resource loadBalancer 'Microsoft.Network/loadBalancers@2025-07-01' = {
  name: loadBalancerName
  location: location
  tags: tags
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: frontend1Name
        properties: {
          privateIPAddress: frontendIps[0]
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: frontendSubnet1.id
          }
          privateIPAddressVersion: 'IPv4'
        }
        zones: [
          '1'
          '2'
          '3'
        ]
      }
      {
        name: frontend2Name
        properties: {
          privateIPAddress: frontendIps[1]
          privateIPAllocationMethod: 'Static'
          subnet: {
            id: frontendSubnet2.id
          }
          privateIPAddressVersion: 'IPv4'
        }
        zones: [
          '1'
          '2'
          '3'
        ]
      }
    ]

    backendAddressPools: [
      {
        name: backendPool1Name
        properties: {
          loadBalancerBackendAddresses: [
            {
              name: 'FW001-ETH1.1'
              properties: {
                ipAddress: backendPool1Ips[0]
                virtualNetwork: {
                  id: vnet.id
                }
              }
            }
            {
              name: 'FW002-ETH1.1'
              properties: {
                ipAddress: backendPool1Ips[1]
                virtualNetwork: {
                  id: vnet.id
                }
              }
            }
          ]
        }
      }
      {
        name: backendPool2Name
        properties: {
          loadBalancerBackendAddresses: [
            {
              name: 'FW001-ETH1.2'
              properties: {
                ipAddress: backendPool2Ips[0]
                virtualNetwork: {
                  id: vnet.id
                }
              }
            }
            {
              name: 'FW002-ETH1.2'
              properties: {
                ipAddress: backendPool2Ips[1]
                virtualNetwork: {
                  id: vnet.id
                }
              }
            }
          ]
        }
      }
    ]

    loadBalancingRules: [
      {
        name: rule1Name
        properties: {
          frontendIPConfiguration: {
            id: frontend1Id
          }
          frontendPort: 0
          backendPort: 0
          enableFloatingIP: true
          idleTimeoutInMinutes: 4
          protocol: 'All'
          enableTcpReset: true
          loadDistribution: 'SourceIPProtocol'
          disableOutboundSnat: true
          backendAddressPool: {
            id: backendPool1Id
          }
          probe: {
            id: probeId
          }
        }
      }
      {
        name: rule2Name
        properties: {
          frontendIPConfiguration: {
            id: frontend2Id
          }
          frontendPort: 0
          backendPort: 0
          enableFloatingIP: true
          idleTimeoutInMinutes: 4
          protocol: 'All'
          enableTcpReset: true
          loadDistribution: 'SourceIPProtocol'
          disableOutboundSnat: true
          backendAddressPool: {
            id: backendPool2Id
          }
          probe: {
            id: probeId
          }
        }
      }
    ]

    probes: [
      {
        name: probeName
        properties: {
          protocol: 'Tcp'
          port: 80
          intervalInSeconds: 5
          numberOfProbes: 1
          probeThreshold: 1
        }
      }
    ]

    inboundNatRules: []
    outboundRules: []
    inboundNatPools: []
  }
}
