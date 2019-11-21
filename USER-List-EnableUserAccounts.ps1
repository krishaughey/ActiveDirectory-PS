#Enable user accounts from list then export the results to txt
$UserListFile = "C:\Temp\UserListFile.txt"
$Users = Get-Content $UserListFile

$Action = foreach ($U in $Users)
{
   Get-ADUser -Identity $U | Enable-ADAccount
   Start-Sleep 1
   Get-ADuser -Identity $U -Properties samAccountName, userPrincipalName, Enabled | select samAccountName, userPrincipalName, Enabled
}
$Action | Format-Table -AutoSize | Out-File C:\Temp\UserEnableResults.txt
