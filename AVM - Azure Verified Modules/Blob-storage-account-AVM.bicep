module storageAccount 'br/public:avm/res/storage/storage-account:0.9.1' = {
  name: 'storageAccountDeployment'
  params: {
    // Required parameters
    name: 'ssablob001deltmp'
    // Non-required parameters
    kind: 'BlobStorage'
    skuName: 'Standard_LRS'
  }
}
