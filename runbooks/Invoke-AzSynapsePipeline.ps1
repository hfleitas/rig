Param(
    $workspace = "wplushiramsynapse",
    $pipeline = "params",
	$key = $null, #"p1"
	$val = $null #5
)

# login
$null = Connect-AzAccount -Identity

#add to hashtable
$p = @{}
$p.Add($key,$val)

#run pipeline
$RunId = Invoke-AzSynapsePipeline -WorkspaceName $workspace -PipelineName $pipeline -Parameter $p 
$RunId 

#Write-Host ($RunId | ConvertTo-Json)
