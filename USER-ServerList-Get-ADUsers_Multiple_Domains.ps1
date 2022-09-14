Import-Module ActiveDirectory
$ServerList = Get-Content c:\Temp\ServerList.txt

foreach ($Server in $ServerList){
Get-ADUser -Server $server -Filter {-not ( lastlogontimestamp -like "*") -and (enabled -eq $true) -and (passwordNeverExpires -ne "true") } | Export-Csv c:\Temp\"$Server"_NoLogon.csv -NoTypeInformation
Get-ADUser -Server $server -Filter * -Properties Name,Enabled,LastlogonTimeStamp,PasswordNeverExpires | Where-Object {([datetime]::FromFileTime($_.lastlogonTimeStamp) -le (Get-Date).adddays(-180)) -and ($_.passwordNeverExpires -ne "true") } | Export-CSV c:\Temp\"$Server"_180days.csv -NoTypeInformation
}
