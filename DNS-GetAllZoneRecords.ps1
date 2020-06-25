# Get all Zone records for all Zones on a DNS Server

$Server = Read-Host -Prompt "Enter the hostname of the DNS server -->"
$zones = Invoke-Command -ComputerName NS01.card.com -ScriptBlock { Get-DNSServerZone | Select -ExpandProperty ZoneName }
$results = foreach ($zone in $zones) {
    $zoneData = Get-DnsServerResourceRecord $zone
    foreach ($record in $zoneData)
    {
        [PSCustomObject]@{
            ZoneName = $zone
            HostName = $record.HostName
            RecordType = $record.RecordType
            RecordData = $record.RecordData
        }
    }
}
$results | Out-GridView
$results | Export-Csv -Path C:\temp\DNSRecords.csv -NoTypeInformation
