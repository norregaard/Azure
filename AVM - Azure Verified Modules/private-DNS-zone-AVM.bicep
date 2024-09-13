module privateDnsZone 'br/public:avm/res/network/private-dns-zone:0.6.0' = {
  name: 'privateDnsZoneDeployment'
  params: {
    // Required parameters
    name: 'privatelink.vaultcore.azure.net'
    // Non-required parameters
    location: 'global'
    virtualNetworkLinks: [
      {
        registrationEnabled: false
        virtualNetworkResourceId: '<VNet resource id>'
      }
    ]
  }
}
