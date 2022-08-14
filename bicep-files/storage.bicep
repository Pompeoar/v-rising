param location string = resourceGroup().location
param volumeMountName string = 'saves'


var storage_name = 'vrising${uniqueString(resourceGroup().id)}'

resource storage 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: storage_name
  location: location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }

  resource files 'fileServices' = {
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
