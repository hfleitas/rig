# https://techcommunity.microsoft.com/t5/azure-synapse-analytics/how-to-start-synapse-pipeline-from-rest-api/ba-p/1684836
# https://ms.web.azuresynapse.net/en-us/authoring/analyze/pipeline/wait?workspace=%2Fsubscriptions%2Fe4e06275-58d1-4081-8f1b-be12462eb701%2FresourceGroups%2Fwplushiramsynapse%2Fproviders%2FMicrosoft.Synapse%2Fworkspaces%2Fwplushiramsynapse
# https://ms.portal.azure.com/#@microsoft.onmicrosoft.com/resource/subscriptions/e4e06275-58d1-4081-8f1b-be12462eb701/resourceGroups/wplushiramsynapse/providers/Microsoft.Synapse/workspaces/wplushiramsynapse/overview

##############################
## CREATE SERVICE PRINCIPAL ##
##############################

$subscriptionId = "e4e06275-58d1-4081-8f1b-be12462eb701"
$resourceGroupName = "wplushiramsynapse"

# Authenticate to a specific Azure subscription.
Connect-AzAccount -SubscriptionId $subscriptionId

# Password for the service principal
$pwd = "MSdemoSP2021synapse@uto"
$secureStringPassword = ConvertTo-SecureString -String $pwd -AsPlainText -Force

# Create a new Azure AD application
$azureAdApplication = New-AzADApplication `
    -DisplayName "JarvisSynapseCreateRun" `
    -HomePage "https://wplushiramsynapse.dev.azuresynapse.net" `
    -Password $secureStringPassword

# Create a new service principal associated with the designated application
New-AzADServicePrincipal -ApplicationId $azureAdApplication.ApplicationId

# Assign Reader role to the newly created service principal
New-AzRoleAssignment -RoleDefinitionName Reader -ServicePrincipalName $azureAdApplication.ApplicationId.Guid

###################
## BUILD REQUEST ##
###################

$pwd = "MSdemoSP2021synapse@uto"
$azureAdApplication = Get-AzADApplication -DisplayName "JarvisSynapseCreateRun"

$subscriptionId = "e4e06275-58d1-4081-8f1b-be12462eb701"
$subscription = Get-AzSubscription -SubscriptionId $subscriptionId

$clientId = $azureAdApplication.ApplicationId.Guid
$tenantId1 = $subscription.TenantId
$authUrl = "https://login.microsoftonline.com/${tenantId1}/oauth2/token"
$cred = New-Object -TypeName Microsoft.IdentityModel.Clients.ActiveDirectory.ClientCredential -ArgumentList ($clientId, $pwd)

$AuthContext = [Microsoft.IdentityModel.Clients.ActiveDirectory.AuthenticationContext]$authUrl 
$result = $AuthContext.AcquireTokenAsync("https://dev.azuresynapse.net", $cred).GetAwaiter().GetResult()

# Build an array of HTTP header values
$authHeader = @{
'Content-Type'='application/json'
'Accept'='application/json'
'Authorization'=$result.CreateAuthorizationHeader()
}

$request = "https://YourWorkspaceName.dev.azuresynapse.net/pipelines/YourPipelineName/createRun?api-version=2018-06-01"
$body =  @"
{
    "name": "YourWorkspaceName",
    "location": "Region",
    "properties": {},
    "identity": {
        "type": "SystemAssigned"
    }
}
"@

$response = Invoke-RestMethod -Method POST -Uri $request -Header $authHeader -Body $body
$response | ConvertTo-Json
$runId = $response.runId