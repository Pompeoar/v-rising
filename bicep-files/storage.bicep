param location string = resourceGroup().location
param volumeMountName string = 'saves'


var storage_name = 'necesse${uniqueString(resourceGroup().id)}'

resource necesseStorage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storage_name
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }

  resource necesseFiles 'fileServices' = {
    name: 'default'   

    resource share 'shares' = {
      name: volumeMountName
      properties: {
        accessTier: 'TransactionOptimized'
        shareQuota: 5120
      }
    }
  }
}
