## Add Secondary Zone
##### Add a list of secondary DNS zones to an existing AD DNS server

$DnsServer = Read-Host -Input "Enter the DNS Server to add the zones to -->"
$DomainName = Read-Host -Input "Enter the Domain name -->"
$Secondary = "C:\TEMP\SecondaryZoneServers.txt"
$SecList = Import-Csv $Secondary
Foreach ($Server in $SecList)
{
Set-DnsServerPrimaryZone -ComputerName $HostName.$DomainName -Name “$DomainName” -SecondaryServers $SecList.IP –SecureSecondaries TransferToSecureServers
}
