Param(
    $workspace = "synapsehiram2",
    $pipeline = "wait",
    $rg = "rig",
    $trigger = "daily5am"
)

# login
$null = Connect-AzAccount -ServicePrincipal `
    -Tenant 'yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyy' `
    -ApplicationId '00000000-0000-0000-0000-00000000' `
    -CertificateThumbprint 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

# run pipeline
$ws = Get-AzSynapseWorkspace -Name $workspace -ResourceGroup $rg
$ws | Invoke-AzSynapsePipeline -PipelineName $pipeline

# enable trigger
if ($null -ne $trigger)
{
    $trig | Get-AzSynapseTrigger -WorkspaceName $workspace -name 'test'
}