Param(
    $workspace = "wplushiramsynapse",
    $pipeline = "wait"
)

# login
$null = Connect-AzAccount -Identity

#run pipeline
$RunId = Invoke-AzSynapsePipeline -WorkspaceName $workspace -PipelineName $pipeline
$RunId 

#Write-Host ($RunId | ConvertTo-Json)
