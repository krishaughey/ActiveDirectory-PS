# Update Contact attributes from CSV and export results
Import-Module ActiveDirectory
$OU = "OU=Client Contacts,OU=Contacts,DC=card,DC=com"
$Department = "CARDParents"
$ContactList = Get-ADObject -Filter 'objectClass -eq "contact"' -SearchBase $OU

Foreach ($Contact in $ContactList)
{
   $u = Get-ADObject -Identity $Contact.distinguishedName -properties Department
   $u | Set-ADObject -Add @{Department = 'CARDParents'}

}
