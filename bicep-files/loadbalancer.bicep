param lbName string = 'lb-vrising'
param location string = 'eastus2'
param publicIpName string = 'ip-vrising'
param vnetName string = 'vn-vrising'
var frontEndIpConfigName = 'ip-cfg-vrising'
var loadBalancerBackendName = 'backend-pool-vrising'

resource vnet 'Microsoft.Network/virtualNetworks@2021-08-01' existing = {
  name: vnetName
}

resource publicIp 'Microsoft.Network/publicIPAddresses@2021-08-01' existing = {
  name: publicIpName
}

resource loadBalancerExternal 'Microsoft.Network/loadBalancers@2021-08-01' = {
  name: lbName
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    frontendIPConfigurations: [
      {
        name: frontEndIpConfigName
        properties: {
          publicIPAddress: {
            id: publicIp.id
          }
        }
      }
    ]
    backendAddressPools: [
      {
        name: loadBalancerBackendName       
      }
    ]
    inboundNatRules: [
      {
        name: 'nat-inbound-vrising'
        properties: {
          frontendIPConfiguration: {
            id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, frontEndIpConfigName)
          }
          protocol: 'Udp'
          frontendPort: 0
          backendPort: 9876
          enableFloatingIP: false
          frontendPortRangeStart: 9876
          frontendPortRangeEnd: 9877
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, loadBalancerBackendName)
          }
        }
      }
    ]
    outboundRules: [
      {
        name: 'idc-outbound-rule-name'
        properties: {
          allocatedOutboundPorts: 64000
          protocol: 'Udp'
          enableTcpReset: false
          idleTimeoutInMinutes: 4
          backendAddressPool: {
            id: resourceId('Microsoft.Network/loadBalancers/backendAddressPools', lbName, loadBalancerBackendName)
          }
          frontendIPConfigurations: [
            {
              id: resourceId('Microsoft.Network/loadBalancers/frontendIPConfigurations', lbName, frontEndIpConfigName)
            }
          ]
        }
      }
    ]
    loadBalancingRules: []
    probes: []
  }
}

resource backendAddresspool 'Microsoft.Network/loadBalancers/backendAddressPools@2021-08-01' = {
  name: loadBalancerBackendName
  parent: loadBalancerExternal
  properties: {
    loadBalancerBackendAddresses: [
      {
        name: guid(loadBalancerBackendName)
        properties: {
          ipAddress: '10.0.0.4'
          virtualNetwork: {
            id: vnet.id
          }
        }
      }
    ]
  }
}
