Param(
    $ws = "wplushiramsynapse",
    $pn = "wait",
)

# login
Connect-AzAccount -Identity

# get token
$t = (Get-AzAccessToken -Resource "https://dev.azuresynapse.net").Token
$h = @{ Authorization = "Bearer $t" }

# do stuff
$uri = "https://$ws.dev.azuresynapse.net/pipelines/$pn/createRun?api-version=2020-12-01"
$uri
$result = Invoke-RestMethod -Method POST -ContentType "application/json" -Uri $uri -Headers $h 
Write-Host ($result | ConvertTo-Json)
