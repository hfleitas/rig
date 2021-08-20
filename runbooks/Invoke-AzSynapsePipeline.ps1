Param(
    [Parameter(Mandatory=$false)]
    [string]$RunAs = "AzureRunAsConnection",
    [Parameter(Mandatory=$false, HelpMessage="Synapse workspace name")]
    [string]$workspace = "wplushiramsynapse",
    [Parameter(Mandatory=$false, HelpMessage="Name of the pipeline you want to run.")]
    [string]$pipeline = "wait",
    [Parameter(Mandatory=$false, HelpMessage="ResourceGroup of Synapse Workspace.")]
    [string]$rg = "wplushiramsynapse",
    [Parameter(Mandatory=$false, HelpMessage="SubscriptionID of Synapse Workspace.")]
    [string]$subid = 'e4e06275-58d1-4081-8f1b-be12462eb701'
)

#connect
$con = Get-AzAutomationConnection -Name $RunAs -ResourceGroup jarvis -AutomationAccountName jarvis
$val = ($con | select -exp FieldDefinitionValues)

#login
$null = Connect-AzAccount -ServicePrincipal `
    -Tenant $val.TenantId `
    -ApplicationId $val.ApplicationId `
    -CertificateThumbprint $val.CertificateThumbprint

# #run pipeline
$ws = Get-AzSynapseWorkspace -Name $workspace -ResourceGroup $rg 
$ws | Invoke-AzSynapsePipeline -PipelineName $pipeline