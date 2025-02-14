module vault 'br/public:avm/res/key-vault/vault:0.11.3' = {
  name: 'vaultDeployment'
  params: {
    // Required parameters
    name: 'keyvaultname001'
    // Non-required parameters
    enablePurgeProtection: false
    privateEndpoints: [
      {
        privateDnsZoneGroup: {
          privateDnsZoneGroupConfigs: [
            {
              privateDnsZoneResourceId: 'PDNS zone resource ID'
            }
          ]
        }
        subnetResourceId: '<snet resource ID>'
      }
    ]
  }
}
