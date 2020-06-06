## GPUpdate on OU
##### Force a group policy update on an OU of machines (random delay of 10 minutes)
##### author: Kristopher F. Haughey
#$ErrorActionPreference= 'silentlycontinue'
Import-Module ActiveDirectory
Import-Module GroupPolicy
Write-Host "Enter the searchbase (e.g. <DC=CONTOSO,DC=COM>)" -ForegroundColor Green
$SearchBase = Read-Host -Prompt "-->"
$HostList = get-adcomputer -Filter * -SearchBase $SearchBase | Select-Object Name,dnshostname

Foreach ($Name in $HostList)
{
    Invoke-GPUpdate $Name -Force -AsJob -RandomDelayInMinutes 10
}
