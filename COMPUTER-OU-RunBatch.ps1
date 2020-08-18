# Run Batch File on Servers in an OU
##### author: Kristopher F. Haughey

$SearchBase = "OU=Servers,DC=Card,DC=com"
$ServerList = Get-Adcomputer -Filter 'operatingsystem -like "*server*" -and enabled -eq "true"' -SearchBase $SearchBase | select DNSHostName
foreach($Server in $Serverlist){
    Invoke-Command -ComputerName $Server.DNSHostName -ScriptBlock {Start-Process "cmd.exe"  "/c \\CARD.com\SysVol\CARD.com\Policies\{D6FD07AB-9810-4151-B910-B466AF63B120}\Machine\Scripts\Startup\NTPClientRepair.bat"}
}
