param(
    $ws = "wplushiramsynapse",  #wplushiramsynapse (dev), hfpocws1 (prod)
    $ts = "Daily,Hourly,Last Day of Month", #list of triggers
    $status = "Start" #Start, Stop
)

# login
$null = Connect-AzAccount -ServicePrincipal `
    -Tenant '72f988bf-86f1-41af-91ab-2d7cd011db47' `
    -ApplicationId '796b542e-3a3e-4ae0-b481-78f24a867c50' `
    -CertificateThumbprint '87F88B7B37DB22E8A52031BD6ABD751D579A3664'

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
