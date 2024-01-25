# Set a specific attribute on all users in a chosen domain in the trust
# change line 1 to the appropriate domain
### author: Kristopher F. Haughey

$AdDomain = "<DOMAIN>
$AllUsers = Get-ADUser -Server $AdDomain -Filter *

foreach ($u in $AllUsers){
    Set-ADObject -Server $AdDomain -Identity $u.DistinguishedName -replace @{preferredLanguage="en-US"}
}
