# Set a specific attribute on a single user in a chosen domain in the trust
# change line 1 to the appropriate domain
# change line 2 to the appropriate user
### author: Kristopher F. Haughey

$AdDomain = "<DOMAIN NAME>"
$u = Get-ADUser "<USER samAccountName>" -Server $AdDomain
Set-ADObject -Server $AdDomain -Identity $u.DistinguishedName -replace @{preferredLanguage="en-US"}
