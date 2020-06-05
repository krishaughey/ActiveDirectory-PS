## GPUpdate on OU
##### Force a group policy update on an OU of machines (random delay of 10 minutes)
##### author: Kristopher F. Haughey

#$ErrorActionPreference= 'silentlycontinue'
Write-Host "Enter the searchbase (e.g. <DC=CONTOSO,DC=COM>)" -ForegroundColor Green
$SearchBase = Read-Host -Prompt "-->"
$ServerList = get-adcomputer -Filter * -SearchBase $SearchBase | Select-Object Name,dnshostname

Foreach ($hostname in $list)
{
    Invoke-GPUpdate $hostname -Force -AsJob -RandomDelayInMinutes 10
}
