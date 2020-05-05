## Report Hosts in AD
## BROKEN AF >>> DO NOT USE Line 25-30 are trash


#### Get Forest sites and subnets, run Nmap discovery on those subnets, and export results
##### https://www.powershellgallery.com/packages/xNmap/1.0.7
##### author: Kristopher F. Haughey

#Write-host "adding Nmap to $env:Path..."
#Install-Module -Name xNmap
$OutputPath = "c:\Temp\"
Write-host "getting all sites and subnets from current forest" -ForegroundColor Yellow

$sites = [System.DirectoryServices.ActiveDirectory.Forest]::GetCurrentForest().Sites
$sitesubnets = @()

foreach ($site in $sites){
	foreach ($subnet in $site.subnets){
	   $temp = New-Object PSCustomObject -Property @{
	   'Site' = $site.Name
	   'Subnet' = $subnet; }
	 $sitesubnets += $temp
 	}
}
 foreach ($subnet in $site.subnets){
 	 $temp2 = New-Object PSCustomObject -Property @{
 	 'Site' = $site.Name
 	 'Subnet' = $subnet; }
  $NmapOutput += $temp2
}

write-host "exporting to CSV"
$sitesubnets | Export-CSV $OutputPath-AD-SitesSubnets-Report.csv
$NmapOutput | Export-CSV $OutputPath-AD-SitesSubnets-NmapOutput.csv
