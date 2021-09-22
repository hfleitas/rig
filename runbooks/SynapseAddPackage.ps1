Param(
    $workspace = "synapsehiram2",
    $rg = "rig",
    $pkg = "path/to/package.whl",
    $pool = "hirampool"
)

# login
$null = Connect-AzAccount -ServicePrincipal `
    -Tenant 'yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyy' `
    -ApplicationId '00000000-0000-0000-0000-00000000' `
    -CertificateThumbprint 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'

#pkg
$newpkg = New-AzSynapseWorkspacePackage -WorkspaceName $workspace -Package $pkg
Update-AzSynapseSparkPool -WorkspaceName $workspace -Name $pool -PackageAction Add -Package $newpkg
