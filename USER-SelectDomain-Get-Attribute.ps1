# change line 1 to the appropriate domain
# change line 2 to the appropriate user
$AdDomain = "<DOMAIN NAME>"
$u = Get-ADUser "<USER samAccountName>" -Server $AdDomain
Get-ADuser -Server $AdDomain -Identity $u.DistinguishedName -properties preferredLanguage | select samaccountname,preferredLanguage 
