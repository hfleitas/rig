Param(
    $ws = "synapsehiram2",
    $days = "-7"
)

# login
$null = Connect-AzAccount -ServicePrincipal `
    -Tenant 'aaaa-aaaa-aaaa-aaaa-aaaa' `
    -ApplicationId 'bbbb-bbbb-bbbb-bbbb-bbbb' `
    -CertificateThumbprint 'cccccccccccccccccccccccccccccccc'

# get runs
$a = $(get-date).adddays($days)
$b = get-date
$result = Get-AzSynapsePipelineRun -WorkspaceName $ws -RunStartedAfter $a -RunStartedBefore $b

Write-Output $result
