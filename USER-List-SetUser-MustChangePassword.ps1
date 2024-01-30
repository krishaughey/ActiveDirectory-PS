#Set User Must Change Password from list of users
$timestamp = Get-Date -Format s | ForEach-Object { $_ -replace ":", "." }
Import-Module ActiveDirectory

$domain = "<DOMAIN>"

$UserList = Get-Content C:\Temp\UserList.txt

foreach($user in $UserList){
	Set-ADUser -Identity $User -Server $domain -ChangePasswordAtLogon:$true
}
Write-Host "Process Complete $timestamp" -foregroundcolor cyan
