#Prompts for a sAMAccountName to get-ADuser attributes

write-host "enter the sAMAccountName of the user and press ENTER (e.g.- khaughey)" -ForegroundColor Cyan

$input = Read-Host -Prompt "--->"
$User = $input

Get-ADuser -Identity $input -properties * | select displayname, userPrincipalName , DistinguishedName, Enabled, AccountExpirationDate | Export-csv c:\Temp\$input.csv

write-host "**COMPLETE**" -ForegroundColor Yellow
Write-host "RESULTS have been saved to ---> c:\Temp\$input.csv" -ForegroundColor Cyan

Write-Host -NoNewLine 'Press any key to EXIT...' -ForegroundColor White;
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
