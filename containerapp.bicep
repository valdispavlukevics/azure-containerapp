param containerImage string = ''
param location       string = ''
param environment    string = ''

// Container App
resource containerapps 'Microsoft.Web/containerapps@2021-03-01' = {
  name: 'container-apps'
  kind: 'containerapps'
  location: location
  properties: {
    kubeEnvironmentId: kubeEnvironment.id
    configuration: {
      ingress: {
        external: true
        targetPort: 80
      }
    }
    template: {
      containers: [
        {
          name: 'sample-container-${environment}'
          image: containerImage
          resources: {
            cpu: '0.25'
            memory: '.5Gi'
          }
        }
      ]
    }
  }
}

// Container App Environment
resource kubeEnvironment 'Microsoft.Web/kubeEnvironments@2021-03-01' = {
  name: 'kube-environment'
  location: location
  properties: {
    environmentType: 'managed'
    internalLoadBalancerEnabled: false
    appLogsConfiguration: {
      destination: 'log-analytics'
      logAnalyticsConfiguration: {
        customerId: reference('Microsoft.OperationalInsights/workspaces/${workspace.name}', '2020-08-01').customerId
        sharedKey: listKeys('Microsoft.OperationalInsights/workspaces/${workspace.name}', '2020-08-01').primarySharedKey
      }
    }
  }
}

// Describe Log Analytics Workspace
resource workspace 'Microsoft.OperationalInsights/workspaces@2021-12-01-preview' = {
  name: 'log-workspace'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    workspaceCapping: {
      dailyQuotaGb: 1
    }
  }
}
