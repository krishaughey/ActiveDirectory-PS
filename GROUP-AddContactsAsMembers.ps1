# Add Contacts to Group
## Adds contacts from an OU to a Group
#### author: Kristopher F. Haughey
Import-Module ActiveDirectory
$ErrorActionPreference = 'silentlycontinue'

$OU = "OU=Client Contacts,OU=Contacts,DC=CARD,DC=com"
$Group = Get-AdGroup "CN=Parents,OU=Groups,DC=CARD,DC=com"
$Contacts = Get-ADObject -Filter 'objectClass -eq "contact"' -SearchBase $OU

Foreach ($Contact in $Contacts){
    Add-ADGroupMember $Group -Members $Contact
}
