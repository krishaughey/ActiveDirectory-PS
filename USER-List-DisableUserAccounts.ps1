#Disable user accounts from list then export the results to txt
$UserListFile = "C:\Temp\UserList.txt"
$Users = Get-Content $UserListFile

$Action = foreach ($U in $Users)
{
   Get-ADUser -Identity $U | Disable-ADAccount
   Get-ADuser -Identity $U -Properties samAccountName, userPrincipalName, Enabled | Select-Object samAccountName, userPrincipalName, Enabled
}
$Action | Export-CSV C:\Temp\UserDisableResults.csv -NoTypeInformation
