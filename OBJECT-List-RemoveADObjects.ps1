# REMOVE ADObject from List
## Get the ADObjects from a list, target an OU, and remove the Objects
##### author: Kristopher F. Haughey

$ObjectList = Get-Content c:\Temp\Clients.txt
foreach($Object in $ObjectList) {
    $DN = Get-ADObject -filter {Name -like $Object} -SearchBase "OU=Client Contacts,OU=Contacts,DC=<Domain>,DC=com" -properties distinguishedName | Select-Object distinguishedName
    Remove-ADObject $DN.distinguishedName -Confirm:$false
}
