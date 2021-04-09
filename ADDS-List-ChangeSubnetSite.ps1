# Update Subnet Site Information from List
$Site = "DR"
$Network = Get-Content "c:\Temp\DR_SubnetList.txt"
foreach ($Subnet in $Network) {
    Set-ADReplicationSubnet -identity $Subnet -site $Site
}
