$Secondary = "C:\TEMP\Secondary.csv"
$SecList = Import-Csv $Secondary
Foreach ($Server in $SecList)
{
Set-DnsServerPrimaryZone -ComputerName pwdc074.rlcorp.local -Name “rlcorp.local” -SecondaryServers $SecList.IP –SecureSecondaries TransferToSecureServers
}
