# Get Object Attributes
## Get the selected attributes from an AD ADObject
##### author: Kristopher F. Haughey

$List = Get-Content c:\Temp\Clients.txt
foreach($Object in $List) {
    Get-ADObject -filter {Name -like $Object} -SearchBase "OU=Contacts,DC=<DOMAIN>,DC=com" -properties distinguishedName| Select-Object distinguishedName
}
