param(
    $ws = "wplushiramsynapse",  #wplushiramsynapse (dev), hfpocws1 (prod)
    $ts = "Daily,Hourly,Last Day of Month", #list of triggers
    $status = "Start" #Start, Stop
)

# login
$null = Connect-AzAccount -ServicePrincipal `
    -Tenant 'aaaaa' `
    -ApplicationId 'bbbbb' `
    -CertificateThumbprint 'cccccc'

# enable
if ($status -eq "Start"){
    
    $triggers = $ts.split(",");

    foreach ($t in $triggers) {
        $t
        $trigger = Get-AzSynapseTrigger -WorkspaceName $ws -Name $t
        $trigger | Start-AzSynapseTrigger
    }
}

# disable
if ($status -eq "Stop"){
    
    $triggers = $ts.split(",");

    foreach ($t in $triggers) {
        $t
        $trigger = Get-AzSynapseTrigger -WorkspaceName $ws -Name $t
        $trigger | Stop-AzSynapseTrigger
    }
}

#ref: https://docs.microsoft.com/en-us/rest/api/synapse/data-plane/trigger/get-triggers-by-workspace
