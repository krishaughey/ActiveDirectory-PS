#Prompts for a sAMAccountName to get-ADuser attributes in the current domain
write-host "enter the sAMAccountName of the user and press ENTER (e.g.- khaughey)" -ForegroundColor Cyan

$input = Read-Host -Prompt "--->"
$User = $input

Get-ADuser -Identity $input -properties displayname,userPrincipalName,Enabled,AccountExpirationDate,LastLogon,WhenChanged | select displayname,userPrincipalName,Enabled,AccountExpirationDate,@{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}},WhenChanged | Export-csv c:\Temp\$input.csv

write-host "**COMPLETE**" -ForegroundColor Yellow
Write-host "RESULTS have been saved to ---> c:\Temp\$input.csv" -ForegroundColor Cyan
