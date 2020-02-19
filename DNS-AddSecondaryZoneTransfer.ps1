$Secondary = "C:\TEMP\Secondary.csv"
$SecList = Import-Csv $Secondary
Foreach ($Server in $SecList)
{
Set-DnsServerPrimaryZone -ComputerName HostName.Domain -Name “Domain” -SecondaryServers $SecList.IP –SecureSecondaries TransferToSecureServers
}
