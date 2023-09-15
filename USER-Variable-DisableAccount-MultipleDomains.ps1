#Disable User Account in Multiple Domains in Trust
## Get-ADUser in local domain and trusts, based on filter 'like' string, and disable. *With exemption for one domain line 4 col 42
##### author: Kristopher F. Haughey
$localDom = (Get-AdDomain).DNSRoot
$trusts = Get-ADTrust -Filter {name -ne "<EXCEPTION DOMAIN>"} | Select Name
$userAccount = "<*USER*STRING*>"
$userLocal = Get-ADUser -Filter {name -like $userAccount} -Server $localDom
$userLocal | Disable-ADAccount

$userTrusts = foreach($domain in $trusts) {
    Get-ADUser -Filter {name -like $userAccount} -Server $domain.Name | Disable-ADAccount
    Get-ADUser -Filter {name -like $userAccount} -Server $domain.Name
    }
Get-ADUser -Filter {name -like $userAccount} -Server $localDom
$userTrusts
Write-Host "Completed!" -ForegroundColor Cyan