## Get AD Sites and Subnets
#### Get Forest sites and subnets and export to csv
##### author: Kristopher F. Haughey

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
$sitesubnets | Export-CSV c:\Temp\ADSubnets.csv
