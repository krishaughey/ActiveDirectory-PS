# Get DHCP Scopes 
## Get all Scopes with Details from a Prompted DHCP Server
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$ServerList = Get-DhcpServerInDC | Select-Object DnsName

$Array = @()
foreach($Server in $ServerList) {
$colItems = Get-DnsServerResourceRecord $Scope -ComputerName $Server.DnsName
    
    foreach ($Record in $colItems){
        $Array += New-Object PSObject -Property ([ordered]@{
            'ZoneName' = $Zone})
    }
}
$Array | Export-Csv -Path C:\temp\DHCP_Scopes_$timestamp.csv -NoTypeInformation
Write-Host "Export available at C:\temp\DHCP_Scopes_$timestamp.csv" -ForegroundColor Cyan
