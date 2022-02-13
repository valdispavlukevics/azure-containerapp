// Change target scope from default (Resource Group) to Subscription
targetScope = 'subscription'

param name            string = ''
param location        string = ''
param containerImage  string = ''
param environment     string = ''

var resourceGroupName = '${name}-${environment}'

// Define Resource Group with name and location
resource containerAppResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name:     resourceGroupName
  location: location
}

module containerAppModule 'containerapp.bicep' = {
  scope: resourceGroup(resourceGroupName)
  name: 'containerAppModule'
  params: {
    containerImage: containerImage
    location: location
    environment: environment
  }
  dependsOn: [
    containerAppResourceGroup
  ]
}
