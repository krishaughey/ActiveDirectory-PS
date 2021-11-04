# Run Process on Servers in an OU
##### author: Kristopher F. Haughey

$SearchBase = "OU=Servers,DC=Card,DC=com"
$ServerList = Get-Adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | select DNSHostName
$Status = foreach($Server in $Serverlist){
    Invoke-Command -ComputerName $Server.DNSHostName -ScriptBlock {w32tm /query /status}
}
$Status | Format-Table
