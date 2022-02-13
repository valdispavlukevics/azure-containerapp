$location = 'northeurope'
$subscription = '*****'
$deploymentName = 'ContainerApp'

# Set subscription
az account set --subscription $subscription

# Create subscription deployment
az deployment sub create `
  --name $deploymentName `
  --location $location `
  --template-file ./main.bicep `
  --parameters ./test.parameters.json
 