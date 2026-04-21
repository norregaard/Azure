param principalId string
param roleDefinitionId string
param virtualMachine_name string
param nameSeed string = 'infoblox-ha-cluster'

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, virtualMachine_name, nameSeed)
  scope: resourceGroup()
  properties: {
    roleDefinitionId: roleDefinitionId
    principalId: principalId
    principalType: 'ServicePrincipal'
  }
}
