$UserListFile = "C:\Temp\UserListFile.txt"
$Users = Get-Content $UserListFile

$Action = foreach ($U in $Users)
{
   Get-ADUser -Identity $U | Enable-ADAccount
   Start-Sleep 1
   Get-ADuser -Identity $U -properties * | select samAccountName, userPrincipalName, Enabled
}
$Action | Format-Table -AutoSize | Out-File C:\Temp\UserDisableResults.txt
