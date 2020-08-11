
$ImportObject = Get-ADObject -filter * -SearchBase "ou=Client Contacts,OU=Contacts,DC=card,DC=com" -properties distinguishedName,Name,msExchHideFromAddressLists
Foreach ($Object in $ImportObject)
{
   $u = $Object.DistinguishedName
   $u | Set-ADOBject -Replace @{msExchHideFromAddressLists = "TRUE"}
   }
