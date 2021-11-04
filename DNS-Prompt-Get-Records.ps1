# Get DNS Records
## Get all Records in a prompted Zone from a prompted DNS Server
##### author: Kristopher F. Haughey
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$Server = Read-Host -Prompt "Enter the hostname of the DNS server -->"
$ZoneList = Read-Host -Prompt "Enter the name of the zone you wish to export -->"

$Array = @()
foreach($Zone in $ZoneList) {
$colItems = Get-DnsServerResourceRecord $Zone -ComputerName $Server
    
    foreach ($Record in $colItems){
        $Array += New-Object PSObject -Property ([ordered]@{
            'ZoneName' = $Zone
            'HostName' = $Record.HostName
            'RecordType' = $Record.RecordType
            'TimeToLive' = $Record.TimeToLive
            'RecordData' = $Record.RecordData})
    }
}
$Array | Export-Csv -Path C:\temp\DNSRecords_$timestamp.csv -NoTypeInformation
Write-Host "Export available at C:\temp\DNSRecords.csv_$timestamp" -ForegroundColor Cyan
