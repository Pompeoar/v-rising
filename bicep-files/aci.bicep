@description('Name for the container group')
param name string = 'aci-vrising'

@description('Location for resource.')
param location string = resourceGroup().location

@description('Container image to deploy. Should be of the form repoName/imagename:tag for images stored in public Docker Hub, or a fully qualified URI for other registries. Images from private registries require additional registry credentials.')
param image string = 'mephi00/v-rising-wine'

@description('Port to open on the container and the public IP address.')
param ports array = [9876, 9877]

@description('The number of CPU cores to allocate to the container.')
param cpuCores int = 1

@description('The amount of memory to allocate to the container in gigabytes.')
param memoryInGb int = 2

param vnetName string = 'vn-vrising'
param volumeMountName string = 'saves'

@description('The behavior of Azure runtime if container has stopped.')
@allowed([
  'Always'
  'Never'
  'OnFailure'
])
param restartPolicy string = 'Always'

var storage_name = 'vrising${uniqueString(resourceGroup().id)}'

resource storage 'Microsoft.Storage/storageAccounts@2021-09-01' existing = {
  name: storage_name
}

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: vnetName
}

resource containerGroup 'Microsoft.ContainerInstance/containerGroups@2021-09-01' = {
  name: name
  location: location
  properties: {
    sku: 'Standard'
    containers: [
      {
        name: name
        properties: {
          image: image
          ports: [for port in ports:{
              port: port
              protocol: 'UDP'
            }]
          resources: {
            requests: {
              cpu: cpuCores
              memoryInGB: memoryInGb
            }
          }
          volumeMounts: [
            {
              mountPath: '/config'
              name: 'config'
              readOnly: false
            }
          ]
        }
      }
    ]
    osType: 'Linux'
    restartPolicy: restartPolicy
    ipAddress: {
      type: 'private'
      ports: [for port in ports:{
        port: port
        protocol: 'UDP'
      }]
    }
    subnetIds: [
      {
        id: vnet.properties.subnets[0].id
      }
    ]
    volumes: [
      {
        azureFile: {
          readOnly: false
          shareName: volumeMountName
          storageAccountName: storage.name
          storageAccountKey: storage.listKeys().keys[0].value
        }
        name: volumeMountName
      }
    ]
  }
}
