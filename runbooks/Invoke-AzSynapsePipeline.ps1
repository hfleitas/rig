Param(
    $workspace = "wplushiramsynapse",
    $pipeline = "params",
    $key = $null, #"p1"
    $val = $null #5
)

# login
$null = Connect-AzAccount -Identity

#add to hashtable
$ht = @{}
$ht.Add($key,$val)

#run pipeline
$RunId = Invoke-AzSynapsePipeline -WorkspaceName $workspace -PipelineName $pipeline -Parameter $ht 
$RunId 

#Write-Host ($RunId | ConvertTo-Json)
