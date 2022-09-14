Import-Module ActiveDirectory
$Server = "<DOMAIN CONTROLLER>”

Get-ADUser -Filter {-not ( lastlogontimestamp -like "*") -and (enabled -eq $true) -and (passwordNeverExpires -ne "true") } | Export-Csv c:\Temp\"$Server"_NoLogon.csv -NoTypeInformation
Get-ADUser -Filter * -Properties Name,Enabled,LastlogonTimeStamp,PasswordNeverExpires | Where-Object {([datetime]::FromFileTime($_.lastlogonTimeStamp) -le (Get-Date).adddays(-180)) -and ($_.passwordNeverExpires -ne "true") } | Select-Object Name,DistinguishedName,Enabled,SamaccountName,@{n='LastLogonTimeStamp';e={[DateTime]::FromFileTime($_.lastlogonTimeStamp)}},PasswordNeverExpires | Export-CSV c:\Temp\"$Server"_180days.csv -NoTypeInformation
