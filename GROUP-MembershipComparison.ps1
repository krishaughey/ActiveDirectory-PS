#Compare Membership of two groups

$Comparison = Get-ADUser -Filter * -Properties memberOf | `
Where-Object {
    $_.memberof.contains('CN=<GROUPNAME-1>,OU=Groups,DC=Contoso,DC=com') -and `
    $_.memberof.contains('CN=<GROUPNAME-2>,OU=Groups,DC=Contoso,DC=com' )
}
$Comparison | ft
