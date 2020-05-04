## Report Hosts in AD
#### Get Forest sites and subnets, run Nmap discovery on those subnets, and export results
##### https://www.powershellgallery.com/packages/xNmap/1.0.7
##### author: Kristopher F. Haughey

Write-host "adding Nmap to $env:Path..."
Install-Module -Name xNmap
Start-Sleep 1
Write-host "getting all sites and subnets from current forest"

$sites = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().Sites
$sitesubnets = @()

foreach ($site in $sites)
{
	foreach ($subnet in $site.subnets){
	   $temp = New-Object PSCustomObject -Property @{
	   'Site' = $site.Name
	   'Subnet' = $subnet; }
	    $sitesubnets += $temp
	}
}

write-host "exporting to CSV"
$sitesubnets | Export-CSV AD-SitesSubnets-NmapOutput.csv
