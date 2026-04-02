#Get All Inactive User Accounts 
## Get all user accounts that are enabled but no logon and inactive by a date threshold (line 7)
##### author: Kristopher F. Haughey

Import-Module ActiveDirectory

##Set variables and format TimeStamp
$days = "-180"

$AdDomain = Get-ADDomain
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
$FileName = "$($AdDomain.Name)-$timestamp.csv"

Get-ADUser -Filter {-not ( lastlogontimestamp -like "*") -and (enabled -eq $true) -and (passwordNeverExpires -ne "true") } | Export-Csv c:\Temp\"$FileName"_NoLogon.csv -NoTypeInformation
Get-ADUser -Filter * -Properties Name,Enabled,LastlogonTimeStamp,PasswordNeverExpires | Where-Object {([datetime]::FromFileTime($_.lastlogonTimeStamp) -le (Get-Date).adddays($days)) -and ($_.passwordNeverExpires -ne "true") } | Select-Object Name,DistinguishedName,Enabled,SamaccountName,@{n='LastLogonTimeStamp';e={[DateTime]::FromFileTime($_.lastlogonTimeStamp)}},PasswordNeverExpires | Export-CSV c:\Temp\"$Filename"_Inactive.csv -NoTypeInformation
